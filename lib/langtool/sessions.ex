defmodule Langtool.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sessions.Session}

  @doc """
  Gets a single session by id.

  ## Examples

      iex> get_session!(id)
      %Session{}

  """
  def get_session!(id) when is_integer(id) do
    Session
    |> Repo.get!(id)
    |> Repo.preload(:user)
  end

  @doc """
  Returns the list of last 5 tasks

  ## Examples

      iex> load_tasks(session_id)
      [%Task{}, ...]

  """
  def load_tasks(session_id) do
    object = define_tasks_owner(session_id)
    object.tasks
    |> Enum.sort(&(&1.id >= &2.id))
    |> Enum.take(5)
  end

  defp define_tasks_owner(session_id) do
    session_id
    |> get_session!()
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

  @doc """
  Updates a session.

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %User{}}

  """
  def update_session(%Session{} = session, session_params) do
    session
    |> Session.changeset(session_params)
    |> Repo.update()
  end
end
