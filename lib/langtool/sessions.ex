defmodule Langtool.Sessions do
  @moduledoc """
  The Sessions context.
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sessions.Session}

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
