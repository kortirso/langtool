defmodule Langtool.Examples do
  @moduledoc """
  The Examples context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations.Translation, Examples.Example}

  @doc """
  Create new translation example

  ## Examples

      iex> create_example(sentence, text, to)
      {:ok, %Position{}}

  """
  def create_example(%Sentence{id: sentence_id}, text, to) do
    Repo.insert %Example{
      sentence_id: sentence_id,
      translation: %Translation{
        source: "yandex",
        text: text,
        locale: to
      }
    }
  end
end
