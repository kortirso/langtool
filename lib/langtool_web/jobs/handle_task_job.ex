defmodule LangtoolWeb.Jobs.HandleTaskJob do
  @moduledoc """
  Background job for handling task for localization
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Tasks.Task, Sentences, Positions, Examples, Translations.Translation}
  alias LangtoolWeb.RoomChannel

  @doc """
  Localize file

  ## Examples

      iex> LangtoolWeb.Jobs.HandleTaskJob.perform(task)

  """
  def perform(task) do
    url = Langtool.File.url({task.file, task}, signed: true)
    file = File.cwd! |> Path.join(url)
    case File.read(file) do
      {:ok, _} -> convert_file(task, file, "yml")
      _ -> task_failed(task)
    end
  end

  defp convert_file(task, file, extension) do
    case I18nParser.convert(file, "yml") do
      {:ok, converted_data, sentences} -> activate_task(task, converted_data, sentences)
      _ -> task_failed(task)
    end
  end

  defp activate_task(task, _converted_data, sentences) do
    {_, task} = task |> Task.localizator_changeset(%{status: "active"}) |> Repo.update()
    RoomChannel.broadcast_completed_task(task)
    translate_task(task, sentences)
  end

  defp translate_task(task, sentences) do
    {:ok, %{"iamToken" => iam_token}} = YandexTranslator.get_iam_token()
    result =
      Enum.map(sentences, fn {index, original} ->
        {index, original, find_sentence(index, original, task, iam_token)}
      end)
    complete_task(task)
  end

  defp find_sentence(index, original, task, iam_token) do
    sentence = Sentences.Sentence |> Repo.get_by(original: original, locale: task.from) |> Repo.preload(:translations)
    case sentence do
      # if sentence does not exist then create it
      nil -> create_sentence(index, original, task, iam_token)
      # if sentence exists then find translation for it
      _ -> find_translation(sentence, task, index, iam_token, original)
    end
  end

  # create sentence with translation and reverse translation
  defp create_sentence(index, original, task, iam_token) do
    {:ok, %{"translations" => [%{"text" => text}]}} = YandexTranslator.translate([iam_token: iam_token, text: original, source: task.from, target: task.to])
    # create translation
    Positions.create_full_position(task, index, original, text)
    # create reverse translation
    Sentences.create_sentence(task, original, text)
    text
  end

  # find translation for sentence
  defp find_translation(sentence, task, index, iam_token, original) do
    available_translation = filter_translations(sentence, task.to)
    case available_translation do
      nil ->
        create_translation(task, index, sentence, iam_token, original)

      _ ->
        Positions.create_position(task, index, available_translation.text, sentence)
        available_translation.text
    end
  end

  defp filter_translations(sentence, to) do
    sentence.translations
    |> Enum.filter(fn %Translation{locale: locale} ->
      locale == to
    end)
    |> Enum.at(0)
  end

  defp create_translation(task, index, sentence, iam_token, original) do
    {:ok, %{"translations" => [%{"text" => text}]}} = YandexTranslator.translate([iam_token: iam_token, text: original, source: task.from, target: task.to])
    Positions.create_position(task, index, text, sentence)
    Examples.create_example(sentence, text, task.to)
    text
  end

  defp complete_task(task) do
    {_, task} = task |> Task.localizator_changeset(%{status: "completed"}) |> Repo.update()
    RoomChannel.broadcast_completed_task(task)
  end

  defp task_failed(task) do
    {_, task} = task |> Task.localizator_changeset(%{status: "failed"}) |> Repo.update()
    RoomChannel.broadcast_completed_task(task)
  end
end
