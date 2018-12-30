defmodule Langtool.Repo.Migrations.CreateSentences do
  use Ecto.Migration

  def change do
    create table(:sentences) do
      add :original, :string

      timestamps()
    end

    alter table(:positions) do
      add :sentence_id, references(:sentences), null: false
    end
  end
end
