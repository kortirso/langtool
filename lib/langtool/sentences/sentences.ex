defmodule Langtool.Sentences do
  @moduledoc """
  The Sentences context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations, Translations.Translation, Examples, Ratings.Rating}

  @doc """
  Gets a sentences with translations from to

  ## Examples

      iex> list_sentences(from, to)
      [%Sentence{}, ...]

  """
  def list_sentences(from, to) do
    translation_query =
      from translation in Translation,
      where: translation.locale == ^to,
      preload: [:user]

    query =
      from sentence in Sentence,
      where: sentence.locale == ^from,
      join: translation in assoc(sentence, :translations),
      preload: [translations: ^translation_query],
      group_by: sentence.id

    Repo.all(query)
  end

  @doc """
  Gets a sentences with translations from to

  ## Examples

      iex> list_translations(sentence_id, to, user_id)
      [%Translation{}, ...]

  """
  def list_translations(sentence_id, to, user_id) do
    rating_query =
      from rating in Rating,
      where: rating.user_id == ^user_id

    translation_query =
      from translation in Translation,
      where: translation.locale == ^to,
      order_by: [desc: translation.total_rating],
      preload: [:user, ratings: ^rating_query]

    query =
      from sentence in Sentence,
      where: sentence.id == ^sentence_id,
      join: translation in assoc(sentence, :translations),
      preload: [translations: ^translation_query],
      group_by: sentence.id

    Repo.one(query).translations
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
  def build_sentence(params) when is_map(params), do: Map.merge(%Sentence{}, params)

  @doc """
  Creates new sentence

  ## Examples

      iex> create_sentence(sentence_params)
      %Sentence{}

  """
  def create_sentence(params) when is_map(params) do
    %Sentence{}
    |> Sentence.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Creates new sentence with translation

  ## Examples

      iex> create_sentence_with_translation(sentence_params, translation)
      %Sentence{}

  """
  def create_sentence_with_translation(params, %Translation{} = translation) when is_map(params) do
    %Sentence{}
    |> Sentence.changeset(params)
    |> Ecto.Changeset.put_assoc(:translations, [translation])
    |> Repo.insert()
  end

  @doc """
  Creates new sentence with translation

  ## Examples

      iex> create_sentence_with_translation(sentence_params, translation_params)
      %Sentence{}

  """
  def create_sentence_with_translation(sentence_params, translation_params) when is_map(sentence_params) and is_map(translation_params) do
    translation = Translations.build_translation(translation_params)

    create_sentence_with_translation(sentence_params, translation)
  end

  @doc """
  Create new reverse sentence

  ## Examples

      iex> create_reverse_sentence(sentence, text, to)

  """
  def create_reverse_sentence(%Sentence{original: original, locale: from}, text, to, user_id) do
    reverse_translation = Translations.get_translation_by(%{text: original, locale: from})
    reverse_sentence = get_sentence_by(%{original: text, locale: to})

    do_create_reverse_sentence(reverse_sentence, reverse_translation, %{locale: to, original: text}, %{locale: from, text: original, user_id: user_id})
  end

  defp do_create_reverse_sentence(nil, nil, sentence_params, translation_params), do: create_sentence_with_translation(sentence_params, translation_params)
  defp do_create_reverse_sentence(nil, %Translation{} = translation, sentence_params, _), do: create_sentence_with_translation(sentence_params, translation)
  defp do_create_reverse_sentence(%Sentence{} = sentence, nil, _, translation_params), do: Translations.create_translation_with_sentence(translation_params, sentence)
  defp do_create_reverse_sentence(%Sentence{} = sentence, %Translation{} = translation, _, _), do: Examples.create_or_find_example_by(%{translation_id: translation.id, sentence_id: sentence.id})
end
