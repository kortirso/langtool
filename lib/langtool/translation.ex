defmodule Langtool.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.Sentence

  schema "translations" do
    field :source, :string
    field :text, :string

    many_to_many :sentences, Sentence, join_through: "examples"

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:source, :text])
    |> validate_required([:text])
  end
end
