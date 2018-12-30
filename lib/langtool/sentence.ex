defmodule Langtool.Sentence do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.Position

  schema "sentences" do
    field :original, :string

    has_many :positions, Position

    timestamps()
  end

  @doc false
  def changeset(sentence, attrs) do
    sentence
    |> cast(attrs, [:original])
    |> validate_required([:original])
  end
end
