defmodule Langtool.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Exgravatar
  alias Comeonin.Bcrypt
  alias Langtool.{Sessions.Session, Translations.Translation, Accounts.User, Ratings.Rating}

  schema "users" do
    field :confirmation_token, :string
    field :confirmed_at, :naive_datetime
    field :email, :string
    field :encrypted_password, :string
    field :role, :string

    has_many :sessions, Session, on_delete: :delete_all
    has_many :tasks, through: [:sessions, :tasks]
    has_many :translations, Translation, on_delete: :nilify_all
    has_many :ratings, Rating, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password, :confirmed_at, :confirmation_token])
    |> validate_required([:email, :encrypted_password])
    |> validate_length(:encrypted_password, min: 10)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
    |> put_change(:confirmed_at, nil)
    |> put_change(:confirmation_token, random_string(24))
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:confirmed_at, :role])
    |> validate_inclusion(:role, ["user", "editor", "admin"])
  end

  def avatar(%User{} = user), do: gravatar_url(user.email, s: 32)

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
