defmodule Langtool.Sentences.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Positions.Position, Translations.Translation}

  schema "sentences" do
    field :original, :string
    field :locale, :string

    has_many :positions, Position

    many_to_many :translations, Translation, join_through: "examples"

    timestamps()
  end

  @doc false
  def changeset(sentence, attrs) do
    sentence
    |> cast(attrs, [:original])
    |> validate_required([:original])
  end
end
