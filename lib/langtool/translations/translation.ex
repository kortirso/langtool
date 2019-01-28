defmodule Langtool.Translations.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sentences.Sentence, Examples.Example, Accounts.User}

  schema "translations" do
    field :text, :string
    field :locale, :string

    belongs_to :user, User

    many_to_many :sentences, Sentence, join_through: Example, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:user_id, :text, :locale])
    |> assoc_constraint(:user)
    |> validate_required([:text, :locale])
    |> unique_constraint(:text, name: :index_translations_uniqueness)
  end
end
