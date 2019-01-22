defmodule Langtool.Examples do
  @moduledoc """
  The Examples context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Translations, Translations.Translation, Examples.Example, Sentences, Sentences.Sentence}

  def create_example(params) when is_map(params) do
    %Example{}
    |> Example.changeset(params)
    |> Repo.insert()
  end

  def create_or_find_example(%Translation{}, %Sentence{}) do
    
  end

  @doc """
  Creates new example for sentence

  ## Examples

      iex> create_example_for_sentence(sentence_id, text, to)
      {:ok, %Example{}}

  """
  def create_example_for_sentence(sentence_id, text, to, reverse? \\ false) do
    sentence = Sentences.get_sentence(sentence_id)
    if reverse?, do: Sentences.create_reverse_sentence(sentence, text, to)
    translation = Translations.get_translation_by(%{text: text, locale: to})

    case translation do
      # translation does not exist
      nil -> Translations.create_translation(%{source: "yandex", text: text, locale: to}, sentence)
      # translation exists, create only example
      _ -> create_or_find_example(translation, sentence)
    end    
  end
end
