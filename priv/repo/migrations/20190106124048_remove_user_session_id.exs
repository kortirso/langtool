defmodule Langtool.Repo.Migrations.RemoveUserSessionId do
  use Ecto.Migration

  def change do
    alter table(:sessions) do
      remove :user_session_id
    end
  end
end
