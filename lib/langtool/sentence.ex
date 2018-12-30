defmodule Langtool.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Position, Translation}

  schema "sentences" do
    field :original, :string

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
