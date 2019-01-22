defmodule Langtool.Repo.Migrations.CreateExamples do
  use Ecto.Migration

  def change do
    create table(:examples) do
      add :sentence_id, references(:sentences), null: false
      add :translation_id, references(:translations), null: false

      timestamps()
    end
  end
end
