defmodule Langtool.Tasks do
  @moduledoc """
  The Tasks context
  """

  import Ecto.Query, warn: false
  alias Langtool.Repo
  alias Langtool.Tasks.Task

  @doc """
  Returns the list of users

  ## Examples

      iex> last_for_user(user_session_id)
      [%Task{}, ...]

  """
  def last_for_user(user_session_id) do
    Repo.all(from task in Task, where: task.user_session_id == ^user_session_id)
    |> Enum.sort(&(&1.id >= &2.id))
    |> Enum.take(-5)
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
    |> Task.changeset(task_params)
    |> Repo.insert()
  end
end
