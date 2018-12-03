defmodule Langtool.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :file, :string
      add :user_session_id, :string
      add :from, :string
      add :to, :string
      add :status, :string

      timestamps()
    end

  end
end
