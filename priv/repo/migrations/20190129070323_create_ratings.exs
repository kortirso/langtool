defmodule Langtool.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def up do
    create table(:ratings) do
      add :user_id, references(:users)
      add :translation_id, references(:translations)
      add :value, :integer
      timestamps()
    end
    create unique_index(:ratings, [:user_id, :translation_id], name: :index_ratings_uniqueness)

    alter table(:translations) do
      add :total_rating, :integer, default: 0
    end
  end

  def down do
    drop table(:ratings)

    alter table(:translations) do
      remove :total_rating
    end
  end
end
