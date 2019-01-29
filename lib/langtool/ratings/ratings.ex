defmodule Langtool.Ratings do
  @moduledoc """
  The Ratings context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Ratings.Rating}

  @doc """
  Creates a rating

  ## Examples

      iex> create_rating(%{field: value})
      {:ok, %Rating{}}

      iex> create_rating(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rating(params \\ %{}) when is_map(params) do
    %Rating{}
    |> Rating.changeset(params)
    |> Repo.insert()
  end
end
