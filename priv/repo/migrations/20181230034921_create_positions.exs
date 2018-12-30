defmodule Langtool.Repo.Migrations.CreatePositions do
  use Ecto.Migration

  def change do
    create table(:positions) do
      add :index, :integer
      add :result, :string
      add :task_id, references(:tasks), null: false

      timestamps()
    end
  end
end
