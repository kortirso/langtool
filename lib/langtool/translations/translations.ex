defmodule Langtool.Translations do
  @moduledoc """
  The Translations context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Translations.Translation}

  @doc """
  Gets a single translation

  ## Examples

      iex> get_translation(123)
      %Translation{}

      iex> get_translation(234)
      nil

  """
  def get_translation(id) when is_integer(id), do: Repo.get(Translation, id)

  @doc """
  Gets a single translation by params

  ## Examples

      iex> get_translation_by(%{text: text, locale: locale})
      %Translation{}

      iex> get_translation_by(%{text: text, locale: locale})
      nil

  """
  def get_translation_by(params \\ %{}) when is_map(params), do: Repo.get_by(Translation, params)

  @doc """
  Updates a translation

  ## Examples

      iex> update_translation(translation, %{field: new_value})
      {:ok, %Translation{}}

      iex> update_translation(translation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_translation(%Translation{} = translation, params \\ %{}) when is_map(params) do
    translation
    |> Translation.changeset(params)
    |> Repo.update()
  end
end
