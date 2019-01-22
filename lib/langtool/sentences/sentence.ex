defmodule Langtool.Sentences.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Positions.Position, Translations.Translation, Examples.Example}

  schema "sentences" do
    field :original, :string
    field :locale, :string

    has_many :positions, Position, on_delete: :delete_all

    many_to_many :translations, Translation, join_through: Example, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(sentence, attrs) do
    sentence
    |> cast(attrs, [:original, :locale])
    |> validate_required([:original, :locale])
  end
end
