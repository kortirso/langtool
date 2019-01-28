defmodule Langtool.Repo.Migrations.AddUsersToTranslations do
  use Ecto.Migration

  def change do
    alter table(:translations) do
      remove :source
      add :user_id, references(:users)
    end
    create index(:translations, [:user_id])
  end
end
