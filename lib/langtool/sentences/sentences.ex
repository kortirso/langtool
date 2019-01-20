defmodule Langtool.Sentences do
  @moduledoc """
  The Sentences context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations.Translation}

  def list_sentences(from, to) do
    query =
      from sentence in Sentence,
      where: sentence.locale == ^from,
      join: translation in assoc(sentence, :translations), on: translation.locale == ^to,
      preload: [:translations]
    Repo.all(query)
  end

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

  @doc """
  Load sentence from example

  ## Examples

      iex> get_from_example(example)
      %Sentence{}

  """
  def get_from_example(example) do
    object = example |> Repo.preload(:sentence)
    query =
      from sentence in Sentence,
      where: sentence.id == ^object.sentence.id,
      join: translation in assoc(sentence, :translations), on: translation.locale == ^object.translation.locale,
      preload: [:translations]
    Repo.one(query)
  end
end
