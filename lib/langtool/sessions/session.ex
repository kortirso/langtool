defmodule Langtool.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sessions.Session, Tasks.Task, Accounts.User}

  schema "sessions" do
    field :user_session_id, :string

    belongs_to :user, User

    has_many :tasks, Task, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:user_session_id, :user_id])
    |> validate_required([:user_session_id])
  end
end
