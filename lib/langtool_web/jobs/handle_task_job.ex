defmodule LangtoolWeb.Jobs.HandleTaskJob do
  @moduledoc """
  Background job for handling task for localization
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Tasks.Task, Sentence, Translation, Position}
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
        {index, original, find_translation(index, original, task, iam_token)}
      end)
    IO.inspect result

    complete_task(task)
  end

  defp find_translation(index, original, %Task{id: task_id, from: from, to: to}, iam_token) do
    case Repo.get_by(Sentence, original: original, locale: from) do
      %Sentence{id: id} -> id
      _ -> create_sentence(index, original, task_id, from, to, iam_token)
    end
  end

  defp create_sentence(index, original, task_id, from, to, iam_token) do
    {:ok, %{"translations" => [%{"text" => text}]}} = YandexTranslator.translate([iam_token: iam_token, text: original, source: from, target: to])
    Repo.insert %Position{
      task_id: task_id,
      index: index,
      result: text,
      sentence: %Sentence{
        original: original,
        translations: [
          %Translation{source: "yandex", text: text, locale: to}
        ]
      }
    }
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
