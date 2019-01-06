defmodule Langtool.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sessions.Session, Tasks.Task, Accounts.User}

  schema "sessions" do
    field :user_session_id, :string

    belongs_to :user, User

    has_many :tasks, Task, on_delete: :delete_all
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:user_session_id, :user_id])
    |> put_change(:user_session_id, random_string(24))
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
