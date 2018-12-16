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

      iex> LangtoolWeb.HandleTaskJob.perform(task)

  """
  def perform(task) do
    Process.sleep(3000)

    {_, task} =
      task
      |> Task.localizator_changeset(%{status: "completed"})
      |> Repo.update()
    RoomChannel.broadcast_completed_task(task)
  end
end
