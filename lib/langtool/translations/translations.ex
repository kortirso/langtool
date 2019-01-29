defmodule Langtool.Translations do
  @moduledoc """
  The Translations context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Translations.Translation, Sentences.Sentence, Sentences, Ratings.Rating}

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
  def get_translation_by(params) when is_map(params), do: Repo.get_by(Translation, params)

  @doc """
  Builds a translation

  ## Examples

      iex> build_translation(%{field: value})
      %Translation{}

  """
  def build_translation(params) when is_map(params), do: Map.merge(%Translation{}, params)

  @doc """
  Creates new translation

  ## Examples

      iex> create_translation(translation_params)
      {:ok, %Translation{}}

      iex> create_translation(translation_params)
      {:error, _}

  """
  def create_translation(params) when is_map(params) do
    %Translation{}
    |> Translation.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Creates new translation with sentence

  ## Examples

      iex> create_translation_with_sentence(translation_params, sentence)
      {:ok, %Translation{}}

      iex> create_translation_with_sentence(translation_params, sentence)
      {:error, _}

  """
  def create_translation_with_sentence(params, %Sentence{} = sentence) when is_map(params) do
    %Translation{}
    |> Translation.changeset(params)
    |> Ecto.Changeset.put_assoc(:sentences, [sentence])
    |> Repo.insert()
  end

  @doc """
  Creates new translation with sentence

  ## Examples

      iex> create_translation_with_sentence(translation_params, sentence_params)
      {:ok, %Translation{}}

      iex> create_translation_with_sentence(translation_params, sentence_params)
      {:error, _}

  """
  def create_translation_with_sentence(translation_params, sentence_params) when is_map(translation_params) and is_map(sentence_params) do
    sentence = sentence_params |> Sentences.build_sentence()

    create_translation_with_sentence(translation_params, sentence)
  end

  @doc """
  Creates new translation or find existed by params

  ## Examples

      iex> create_or_find_translation_by(translation_params)
      %Translation{}

      iex> create_or_find_translation_by(translation_params)
      nil

  """
  def create_or_find_translation_by(params) when is_map(params) do
    case create_translation(params) do
      {:ok, translation} -> translation
      {:error, _} -> get_translation_by(params)
    end
  end

  @doc """
  Updates a translation

  ## Examples

      iex> update_translation(translation, %{field: new_value})
      {:ok, %Translation{}}

      iex> update_translation(translation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_translation(%Translation{} = translation, params) when is_map(params) do
    translation
    |> Translation.changeset(params)
    |> Repo.update()
  end

  @doc """
  Updates a rating for translation

  ## Examples

      iex> update_rating(rating)
      {:ok, %Translation{}}

      iex> update_rating(rating)
      {:error, %Ecto.Changeset{}}

  """
  def update_rating(%Rating{} = rating) do
    case get_translation(rating.translation_id) do
      nil -> {:error, "Translation is not found"}
      translation -> update_translation(translation, %{"total_rating" => translation.total_rating + rating.value})
    end
  end
end
