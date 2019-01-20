defmodule Langtool.Examples do
  @moduledoc """
  The Examples context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Translations, Translations.Translation, Examples.Example}

  @doc """
  Create new translation example

  ## Examples

      iex> create_example(sentence_id, text, to)
      {:ok, %Example{}}

  """
  def create_example(sentence_id, text, to) do
    existed_translation = Translations.get_by_text_locale(text, to)

    case existed_translation do
      # translation does not exist
      nil ->
        Repo.insert %Example{
          sentence_id: sentence_id,
          translation: %Translation{
            source: "yandex",
            text: text,
            locale: to
          }
        }

      # translation exists, create only example
      translation ->
        %Example{}
        |> Example.changeset(%{sentence_id: sentence_id, translation_id: translation.id})
        |> Repo.insert()
    end    
  end
end
