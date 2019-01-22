defmodule Langtool.Translations.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sentences.Sentence, Examples.Example}

  schema "translations" do
    field :source, :string
    field :text, :string
    field :locale, :string

    many_to_many :sentences, Sentence, join_through: Example, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:source, :text, :locale])
    |> validate_required([:text, :locale])
    |> unique_constraint(:text, name: :index_translations_uniqueness)
  end
end
