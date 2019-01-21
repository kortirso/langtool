defmodule Langtool.Sentences do
  @moduledoc """
  The Sentences context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations, Translations.Translation, Examples.Example}

  def list_sentences(from, to) do
    query =
      from sentence in Sentence,
      where: sentence.locale == ^from,
      join: translation in assoc(sentence, :translations), on: translation.locale == ^to,
      preload: [:translations]

    Repo.all(query)
    |> Enum.uniq()
  end

  @doc """
  Gets a single sentence.

  ## Examples

      iex> get_sentence!(123)
      %Sentence{}

  """
  def get_sentence!(id), do: Repo.get!(Sentence, id)

  @doc """
  Find sentence by id with translations

  ## Examples

      iex> get_sentence_by_id(original, locale)
      {:ok, %Sentence{}}

  """
  def get_sentence_by_id(id) do
    Sentence
    |> Repo.get_by(id: id)
    |> Repo.preload(:translations)
  end

  @doc """
  Create new sentence

  ## Examples

      iex> create_sentence(task, original, text)
      {:ok, %Sentence{}}

  """
  def create_sentence(from, original, to, text) do
    Repo.insert %Sentence{
      original: original,
      locale: from,
      translations: [
        %Translation{source: "yandex", text: text, locale: to}
      ]
    }
  end

  @doc """
  Create new reverse sentence

  ## Examples

      iex> create_reverse(sentence_id, text, to)
      {:ok, %Sentence{}}

  """
  def create_reverse(sentence_id, text, to) do
    %Sentence{original: original, locale: from} = get_sentence!(sentence_id)
    reverse_translation = Translations.get_translation_by(%{test: original, locale: from})

    case Repo.get_by(Sentence, original: text, locale: to) do
      # no reverse sentence
      nil ->
        case reverse_translation do
          # no reverse translation
          nil -> create_sentence(to, text, from, original)
          # reverse translation exists
          translation ->
            Repo.insert %Sentence{
              original: text,
              locale: to,
              translations: [translation]
            }
        end

      # reverse sentence exists
      sentence ->
        case reverse_translation do
          # no reverse translation
          nil ->
            Repo.insert %Example{
              sentence: sentence,
              translation: %Translation{
                source: "manual",
                text: original,
                locale: from
              }
            }
          # reverse translation exists
          translation ->
            Repo.insert %Example{
              sentence: sentence,
              translation: translation
            }
        end
    end
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

    get_sentence_by_id(object.sentence.id)
  end
end
