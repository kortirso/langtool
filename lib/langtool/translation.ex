defmodule Langtool.Translation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "translations" do
    field :source, :string
    field :text, :string

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:source, :text])
    |> validate_required([:text])
  end
end
