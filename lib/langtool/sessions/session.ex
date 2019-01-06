defmodule Langtool.Sessions.Session do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Sessions.Session, Tasks.Task, Accounts.User}

  schema "sessions" do
    belongs_to :user, User

    has_many :tasks, Task, on_delete: :delete_all
  end

  @doc false
  def changeset(%Session{} = session, attrs) do
    session
    |> cast(attrs, [:user_id])
  end
end
