defmodule Langtool.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Comeonin.Bcrypt

  schema "users" do
    field :confirmation_token, :string
    field :confirmed_at, :naive_datetime
    field :email, :string
    field :encrypted_password, :string

    timestamps()
  end

  @doc false
  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :encrypted_password, :confirmed_at, :confirmation_token])
    |> validate_required([:email, :encrypted_password])
    |> validate_length(:encrypted_password, min: 10)
    |> unique_constraint(:email)
    |> update_change(:encrypted_password, &Bcrypt.hashpwsalt/1)
    |> update_change(:confirmed_at, nil)
    |> update_change(:confirmation_token, random_string(24))
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:confirmed_at])
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
