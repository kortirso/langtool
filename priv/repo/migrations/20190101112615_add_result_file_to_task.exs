defmodule Langtool.Repo.Migrations.AddResultFileToTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :result_file, :string
    end
  end
end
