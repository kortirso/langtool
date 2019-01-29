defmodule Langtool.Translations.Translation do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sentences.Sentence, Examples.Example, Accounts.User, Ratings.Rating}

  schema "translations" do
    field :text, :string
    field :locale, :string
    field :total_rating, :integer, default: 0

    belongs_to :user, User

    has_many :ratings, Rating, on_delete: :delete_all
    many_to_many :sentences, Sentence, join_through: Example, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(translation, attrs) do
    translation
    |> cast(attrs, [:user_id, :text, :locale, :total_rating])
    |> assoc_constraint(:user)
    |> validate_required([:text, :locale])
    |> unique_constraint(:text, name: :index_translations_uniqueness)
  end
end
