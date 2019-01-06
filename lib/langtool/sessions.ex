defmodule Langtool.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sessions.Session}

  @doc """
  Gets a single session by user_session_id.

  ## Examples

      iex> get_by_session_id(user_session_id)
      %Session{}

  """
  def get_by_session_id(user_session_id) when is_binary(user_session_id) do
    Session
    |> Repo.get_by(user_session_id: user_session_id)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of last 5 tasks

  ## Examples

      iex> load_tasks(user_session_id)
      [%Task{}, ...]

  """
  def load_tasks(user_session_id) do
    object = define_tasks_owner(user_session_id)
    object.tasks
    |> Enum.sort(&(&1.id >= &2.id))
    |> Enum.take(5)
  end

  defp define_tasks_owner(user_session_id) do
    user_session_id
    |> get_by_session_id()
    |> tasks_owner()
    |> Repo.preload(:tasks)
  end

  defp tasks_owner(session) do
    cond do
      session.user_id == nil -> session
      true -> session.user
    end
  end

  @doc """
  Creates a session.

  ## Examples

      iex> create_session()
      {:ok, %Session{}}

  """
  def create_session(session_params \\ %{}) do
    %Session{}
    |> Session.changeset(session_params)
    |> Repo.insert()
  end
end
