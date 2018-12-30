defmodule Langtool.Repo.Migrations.CreateTranslations do
  use Ecto.Migration

  def change do
    create table(:translations) do
      add :source, :string
      add :text, :string

      timestamps()
    end
  end
end
