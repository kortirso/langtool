defmodule Langtool.Tasks do
  @moduledoc """
  The Tasks context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Tasks.Task}
  alias LangtoolWeb.RoomChannel
  alias I18nParser.Detection

  @doc """
  Returns the list of last 5 tasks

  ## Examples

      iex> last_for_user(user_session_id)
      [%Task{}, ...]

  """
  def last_for_user(user_session_id) do
    Repo.all(from task in Task, where: task.user_session_id == ^user_session_id)
    |> Enum.sort(&(&1.id >= &2.id))
    |> Enum.take(5)
  end

  @doc """
  Creates a task

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(task_params \\ %{}) do
    %Task{}
    |> Task.create_changeset(task_params)
    |> Repo.insert()
  end

  @doc """
  Attach file to task

  ## Examples

      iex> attach_file(task, %{field: value})
      {:ok, %{code: "en"}}

  """
  def attach_file(task, task_params \\ %{}) do
    task
    |> Task.file_changeset(task_params)
    |> Repo.update()
  end

  @doc """
  Detects locale for file

  ## Examples

      iex> detect_locale(filename, path)
      {:ok, %{code: "en"}}

      iex> detect_locale(filename, path)
      {:error, ""}

  """
  def detect_locale(filename, path) do
    extension =
      filename
      |> String.split(".")
      |> Enum.at(-1)
    Detection.detect(path, extension)
  end

  @doc """
  Localize file

  ## Examples

      iex> handle_task(task)

  """
  def handle_task(task) do
    Process.sleep(3000)

    {_, task} =
      task
      |> Task.localizator_changeset(%{status: "completed"})
      |> Repo.update()
    RoomChannel.broadcast_completed_task(task)
  end
end