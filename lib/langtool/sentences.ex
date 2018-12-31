defmodule Langtool.Sentences do
  @moduledoc """
  The Sentences context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations.Translation}

  @doc """
  Create new sentence

  ## Examples

      iex> create_sentence(task, original, text)
      {:ok, %Sentence{}}

  """
  def create_sentence(from, original, to, text) do
    Repo.insert %Sentence{
      original: text,
      locale: to,
      translations: [
        %Translation{source: "yandex", text: original, locale: from}
      ]
    }
  end

  @doc """
  Find sentence

  ## Examples

      iex> find_sentence(original, locale)
      {:ok, %Sentence{}}

  """
  def find_sentence(original, locale) do
    Sentence
    |> Repo.get_by(original: original, locale: locale)
    |> Repo.preload(:translations)
  end
end
