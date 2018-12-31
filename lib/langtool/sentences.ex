defmodule Langtool.Sentences do
  @moduledoc """
  The Sentences context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Sentences.Sentence, Translations.Translation, Tasks.Task}

  @doc """
  Create new sentence

  ## Examples

      iex> create_sentence(task, original, text)
      {:ok, %Sentence{}}

  """
  def create_sentence(%Task{from: from, to: to}, original, text) do
    Repo.insert %Sentence{
      original: text,
      locale: to,
      translations: [
        %Translation{source: "yandex", text: original, locale: from}
      ]
    }
  end
end
