defmodule LangtoolWeb.Jobs.HandleTaskJob do
  @moduledoc """
  Background job for handling task for localization
  """

  import Ecto.Query, warn: false
  alias Langtool.{Tasks, Tasks.Task, Sentences, Positions, Examples, Translations.Translation}
  alias LangtoolWeb.RoomChannel

  @doc """
  Localize file

  ## Examples

      iex> LangtoolWeb.Jobs.HandleTaskJob.perform(task)

  """
  def perform(%Task{} = task) do
    url = Langtool.File.url({task.file, task}, signed: true)
    file = File.cwd! |> Path.join(url)
    case File.read(file) do
      # if file is available then start converting
      {:ok, _} -> convert_file(task, file, "yml")
      # if not then failed task
      _ -> task_failed(task)
    end
  end

  defp convert_file(task, file, _) do
    case I18nParser.convert(file, "yml") do
      # if file is converted then activate task
      {:ok, converted_data, sentences} -> activate_task(task, file, converted_data, sentences)
      # if not then failed task
      _ -> task_failed(task)
    end
  end

  defp activate_task(task, file, converted_data, sentences) do
    case Tasks.update_task_status(task, "active") do
      # if task is activated
      {:ok, task} ->
        Tasks.update_file(task, file, converted_data)
        RoomChannel.broadcast_completed_task(task)
        {:ok, result} = Yml.write_to_string(%{task.to => converted_data})
        translate_task(task, sentences, result)

      # for failed activation of task
      _ ->
        task_failed(task)
    end
  end

  defp translate_task(task, sentences, temp_data) do
    result = do_translate(task, sentences)
    case generate_result_file(task, temp_data, result) do
      {:ok, task} -> complete_task(task)
      _ -> task_failed(task)
    end
  end

  defp do_translate(task, sentences) do
    {:ok, %{"iamToken" => iam_token}} = YandexTranslator.get_iam_token()
    Enum.map(sentences, fn {index, original} ->
      {text, sentence} = find_sentence(task, original, iam_token)
      Positions.create_position(task.id, index, text, sentence.id)
      {index, original, text}
    end)
  end

  # attempt to find sentence with translation
  defp find_sentence(task, original, iam_token) do
    sentence = Sentences.find_sentence(original, task.from)
    case sentence do
      # if sentence does not exist then create it
      nil -> create_sentence(task, original, iam_token)
      # if sentence exists then find translation for it
      _ -> find_translation(task, original, iam_token, sentence)
    end
  end

  # create sentence with translation and reverse translation
  defp create_sentence(task, original, iam_token) do
    text = translation_requets(task, original, iam_token)
    # create direct translation
    {:ok, sentence} = Sentences.create_sentence(task.from, original, task.to, text)
    {text, sentence}
  end

  # find translation for sentence
  defp find_translation(task, original, iam_token, sentence) do
    available_translation = filter_translations(sentence, task.to)
    case available_translation do
      # create translation for existed sentence
      nil -> create_translation(task, original, iam_token, sentence)
      # return text from existed translation
      _ -> {available_translation.text, sentence}
    end
  end

  # find first available translation
  defp filter_translations(sentence, to) do
    sentence.translations
    |> Enum.filter(fn %Translation{locale: locale} ->
      locale == to
    end)
    |> Enum.at(0)
  end

  defp create_translation(task, original, iam_token, sentence) do
    text = translation_requets(task, original, iam_token)
    # create translation for existed sentence
    Examples.create_example(sentence.id, text, task.to)
    {text, sentence}
  end

  # return translated text
  defp translation_requets(task, original, iam_token) do
    {:ok, %{"translations" => [%{"text" => text}]}} = YandexTranslator.translate([iam_token: iam_token, text: original, source: task.from, target: task.to])
    text
  end

  defp generate_result_file(task, temp_data, result) do
    Enum.reduce(result, temp_data, fn {index, _, translation}, acc ->
      String.replace(acc, "###{index}##", translation)
    end)
    |> Tasks.save_result_file(task)
  end

  defp complete_task(task) do
    {_, task} = Tasks.update_task_status(task, "completed")
    RoomChannel.broadcast_completed_task(task)
  end

  defp task_failed(task) do
    {_, task} = Tasks.update_task_status(task, "failed")
    RoomChannel.broadcast_completed_task(task)
  end
end
