defmodule Langtool.Repo.Migrations.CreateSessions do
  use Ecto.Migration

  def change do
    create table(:sessions) do
      add :user_session_id, :string
      add :user_id, references(:users)
    end

    alter table(:tasks) do
      add :session_id, references(:sessions), null: false
      remove :user_session_id
    end

    create index(:tasks, [:session_id])
    create index(:sessions, [:user_id])
  end
end
