defmodule LangtoolWeb.Jobs.HandleTaskJob do
  @moduledoc """
  Background job for handling task for localization
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Tasks.Task}
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
    Process.sleep(2000)
    IO.inspect task
    IO.inspect sentences
    complete_task(task)
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
