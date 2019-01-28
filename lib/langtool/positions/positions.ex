defmodule Langtool.Positions do
  @moduledoc """
  The Positions context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Positions.Position}

  @doc """
  Gets a single position

  ## Examples

      iex> get_position(123)
      %Position{}

      iex> get_position(234)
      nil

  """
  def get_position(id), do: Repo.get(Position, id)

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

  @doc """
  Updates a position

  ## Examples

      iex> update_position(position, %{field: new_value})
      {:ok, %Position{}}

  """
  def update_position(%Position{} = position, params) when is_map(params) do
    position
    |> Position.changeset(params)
    |> Repo.update()
  end
end
