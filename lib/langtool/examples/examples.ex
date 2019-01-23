defmodule Langtool.Examples do
  @moduledoc """
  The Examples context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Translations, Examples.Example, Sentences}

  @doc """
  Gets a single example by params

  ## Examples

      iex> get_example_by(%{translation: translation, sentence: sentence})
      %Example{}

      iex> get_example_by(%{translation: translation, sentence: sentence})
      nil

  """
  def get_example_by(params) when is_map(params), do: Repo.get_by(Example, params)

  @doc """
  Creates new example

  ## Examples

      iex> create_example(params)
      {:ok, %Example{}}

      iex> create_example(params)
      {:error, _}

  """
  def create_example(params) when is_map(params) do
    %Example{}
    |> Example.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Creates new example or find existed by params

  ## Examples

      iex> create_or_find_example_by(params)
      %Example{}

      iex> create_or_find_example_by(params)
      nil

  """
  def create_or_find_example_by(params) when is_map(params) do
    case create_example(params) do
      {:ok, example} -> example
      {:error, _} -> get_example_by(params)
    end
  end

  @doc """
  Creates new example for sentence

  ## Examples

      iex> create_example_for_sentence(sentence_id, text, to)
      {:ok, %Translation{}}

      iex> create_example_for_sentence(sentence_id, text, to)
      {:error, _}

      iex> create_example_for_sentence(sentence_id, text, to)
      %Example{}

      iex> create_example_for_sentence(sentence_id, text, to)
      nil

  """
  def create_example_for_sentence(sentence_id, text, to, reverse? \\ false) do
    sentence = Sentences.get_sentence(sentence_id)
    if reverse?, do: Sentences.create_reverse_sentence(sentence, text, to)

    case Translations.get_translation_by(%{text: text, locale: to}) do
      # translation does not exist
      nil ->
        case Translations.create_translation_with_sentence(%{source: "yandex", text: text, locale: to}, sentence) do
          {:ok, translation} -> {:ok, translation}
          _ -> {:error, "Error"}
        end
      # translation exists, create only example
      translation ->
        create_or_find_example_by(%{translation_id: translation.id, sentence_id: sentence.id})
        {:ok, translation}
    end    
  end
end
