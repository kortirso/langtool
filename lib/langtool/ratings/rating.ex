defmodule Langtool.Ratings.Rating do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Accounts.User, Translations.Translation}

  schema "ratings" do
    field :value, :integer

    belongs_to :user, User
    belongs_to :translation, Translation

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:user_id, :translation_id, :value])
    |> assoc_constraint(:user)
    |> assoc_constraint(:translation)
    |> unique_constraint(:user_id, name: :index_ratings_uniqueness)
    |> validate_required([:value])
    |> validate_inclusion(:value, [-1, 1])
  end
end
