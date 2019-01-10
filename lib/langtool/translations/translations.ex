defmodule Langtool.Translations do
  @moduledoc """
  The Translations context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Translations.Translation}

  @doc """
  Gets a single translation.

  ## Examples

      iex> get_translation!(123)
      %Translation{}

  """
  def get_translation!(id), do: Repo.get!(Translation, id)

  @doc """
  Updates a translation.

  ## Examples

      iex> update_translation(translation, %{field: new_value})
      {:ok, %Translation{}}

  """
  def update_translation(%Translation{} = translation, translation_params) do
    translation
    |> Translation.changeset(translation_params)
    |> Repo.update()
  end
end
