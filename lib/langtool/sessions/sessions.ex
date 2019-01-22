defmodule Langtool.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sessions.Session, Accounts.User}

  @doc """
  Gets a single session by id

  ## Examples

      iex> get_session(id)
      %Session{}

      iex> get_session(id)
      nil

  """
  def get_session(id) when is_integer(id), do: Repo.get(Session, id)

  @doc """
  Gets a single session by id with user

  ## Examples

      iex> get_session_with_user(id)
      %Session{}

      iex> get_session_with_user(id)
      nil

  """
  def get_session_with_user(id) when is_integer(id) do
    case get_session(id) do
      nil -> nil
      session -> Repo.preload(session, :user)
    end
  end

  @doc """
  Returns the list of last 5 tasks

  ## Examples

      iex> load_tasks(session_id)
      [%Task{}, ...]

  """
  def load_tasks(session_id) when is_integer(session_id) do
    object = define_tasks_owner(session_id)

    case object do
      nil ->
        []

      _ ->
        object.tasks
        |> Enum.sort(&(&1.id >= &2.id))
        |> Enum.take(5)
    end
  end

  defp define_tasks_owner(session_id) do
    case get_session_with_user(session_id) do
      nil ->
        nil

      object ->
        object
        |> tasks_owner()
        |> Repo.preload(:tasks)
    end
  end

  defp tasks_owner(%Session{user_id: nil} = session), do: session
  defp tasks_owner(session), do: session.user

  @doc """
  Creates a session

  ## Examples

      iex> create_session()
      {:ok, %Session{}}

  """
  def create_session() do
    %Session{}
    |> Session.changeset(%{})
    |> Repo.insert()
  end

  @doc """
  Updates a session

  ## Examples

      iex> update_session(session, %{field: new_value})
      {:ok, %Session{}}

  """
  def update_session(%Session{} = session, params) when is_map(params) do
    session
    |> Session.changeset(params)
    |> Repo.update()
  end

  @doc """
  Attaches a session to user

  ## Examples

      iex> attach_user(session, %{field: new_value})
      {:ok, %Session{}}

      iex> attach_user(session, %{field: new_value})
      nil

  """
  def attach_user(session_id, %User{} = user) when is_integer(session_id) do
    case get_session(session_id) do
      nil -> nil
      session -> update_session(session, %{user_id: user.id})
    end
  end
end
