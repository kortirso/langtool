defmodule Langtool.Examples.Example do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sentences.Sentence, Translations.Translation}

  schema "examples" do
    belongs_to :sentence, Sentence
    belongs_to :translation, Translation
  end

  @doc false
  def changeset(example, attrs) do
    example
    |> cast(attrs, [:sentence_id, :translation_id])
    |> assoc_constraint(:sentence)
    |> assoc_constraint(:translation)
  end
end
