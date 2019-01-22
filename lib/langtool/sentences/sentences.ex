defmodule Langtool.Sentences do
  @moduledoc """
  The Sentences context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations, Translations.Translation, Examples}

  @doc """
  Gets a sentences with translations from to

  ## Examples

      iex> list_sentences(from, to)
      [%Sentence{}, ...]

  """
  def list_sentences(from, to) do
    query =
      from sentence in Sentence,
      where: sentence.locale == ^from,
      join: translation in assoc(sentence, :translations), on: translation.locale == ^to,
      group_by: sentence.id,
      preload: [:translations]

    Repo.all(query)
  end

  @doc """
  Gets a single sentence

  ## Examples

      iex> get_sentence(123)
      %Sentence{}

      iex> get_sentence(234)
      nil

  """
  def get_sentence(id), do: Repo.get(Sentence, id)

  @doc """
  Gets a single sentence with translations

  ## Examples

      iex> get_sentence_with_translations(123)
      %Sentence{}

      iex> get_sentence_with_translations(234)
      nil

  """
  def get_sentence_with_translations(id) do
    case get_sentence(id) do
      nil -> nil
      sentence -> Repo.preload(sentence, :translations)
    end
  end

  @doc """
  Gets a single sentence by params

  ## Examples

      iex> get_sentence_by(params)
      %Sentence{}

      iex> get_sentence_by(params)
      nil

  """
  def get_sentence_by(params) when is_map(params), do: Repo.get_by(Sentence, params)

  @doc """
  Gets a single sentence by params with translations

  ## Examples

      iex> get_sentence_by(params)
      %Sentence{}

      iex> get_sentence_by(params)
      nil

  """
  def get_sentence_with_translations_by(params) when is_map(params) do
    case get_sentence_by(params) do
      nil -> nil
      sentence -> Repo.preload(sentence, :translations)
    end
  end

  @doc """
  Builds a sentence

  ## Examples

      iex> build_sentence(%{field: value})
      %Sentence{}

  """
  def build_sentence(params) when is_map(params), do: Sentence.changeset(%Sentence{}, params)

  @doc """
  Creates new sentence

  ## Examples

      iex> create_sentence(sentence_params, translation_params)
      %Sentence{}

  """
  def create_sentence(sentence_params, translation_params) when is_map(sentence_params) and is_map(translation_params) do
    translation = translation_params |> Map.merge(%{source: "yandex"}) |> Translations.build_translation()

    create_sentence(sentence_params, translation)
  end

  @doc """
  Creates new sentence

  ## Examples

      iex> create_sentence(sentence_params, translation)
      %Sentence{}

  """
  def create_sentence(params, %Translation{} = translation) when is_map(params) do
    params
    |> build_sentence()
    |> Ecto.Changeset.put_assoc(:translations, [translation])
    |> Repo.insert()
  end

  @doc """
  Create new reverse sentence

  ## Examples

      iex> create_reverse_sentence(sentence, text, to)

  """
  def create_reverse_sentence(%Sentence{original: original, locale: from}, text, to) do
    reverse_translation = Translations.get_translation_by(%{text: original, locale: from})
    reverse_sentence = get_sentence_by(%{original: text, locale: to})

    do_create_reverse_sentence(reverse_sentence, reverse_translation, %{locale: to, original: text}, %{locale: from, text: original})
  end

  defp do_create_reverse_sentence(nil, nil, sentence, translation), do: create_sentence(sentence, translation)
  defp do_create_reverse_sentence(nil, %Translation{} = translation, sentence, _), do: create_sentence(sentence, translation)
  defp do_create_reverse_sentence(%Sentence{} = sentence, nil, _, translation), do: Translations.create_translation(translation, sentence)
  defp do_create_reverse_sentence(%Sentence{} = sentence, %Translation{} = translation, _, _), do: Examples.create_or_find_example(translation, sentence)
end
