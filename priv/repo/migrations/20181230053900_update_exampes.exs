defmodule Langtool.Repo.Migrations.AddLocales do
  use Ecto.Migration

  def change do
    alter table(:sentences) do
      add :locale, :string
    end

    alter table(:translations) do
      add :locale, :string
    end
  end
end
