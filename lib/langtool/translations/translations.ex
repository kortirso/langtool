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
  Gets a single translation by text and locale.

  ## Examples

      iex> get_by_text_locale(text, locale)
      %Translation{}

  """
  def get_by_text_locale(text, locale)
    when is_binary(text) and is_binary(locale),
    do: Repo.get_by(Translation, text: text, locale: locale)

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
