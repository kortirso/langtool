defmodule Langtool.Example do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sentence, Translation}

  schema "examples" do
    belongs_to :sentence, Sentence
    belongs_to :translation, Translation

    timestamps()
  end

  @doc false
  def changeset(example, attrs) do
    example
    |> cast(attrs, [:sentence_id, :translation_id])
    |> validate_required([:sentence_id, :translation_id])
  end
end
