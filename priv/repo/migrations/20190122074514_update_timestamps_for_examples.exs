defmodule Langtool.Repo.Migrations.UpdateTimestampsForExamples do
  use Ecto.Migration

  def change do
    alter table(:examples) do
      modify :inserted_at, :naive_datetime, default: fragment("NOW()")
      modify :updated_at, :naive_datetime, default: fragment("NOW()")
    end
  end
end
