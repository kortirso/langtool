defmodule Langtool.Positions do
  @moduledoc """
  The Positions context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Positions.Position}

  @doc """
  Creates new position in task for sentence

  ## Examples

      iex> create_position(%{field: value})
      {:ok, %Position{}}

      iex> create_position(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_position(params) when is_map(params) do
    %Position{}
    |> Position.changeset(params)
    |> Repo.insert()
  end
end
