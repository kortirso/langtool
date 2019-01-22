defmodule Langtool.Repo.Migrations.AddUniquenessIndexes do
  use Ecto.Migration

  def up do
    create unique_index(:examples, [:sentence_id, :translation_id], name: :index_examples_uniqueness)
    create unique_index(:sentences, [:original, :locale], name: :index_sentences_uniqueness)
    create unique_index(:translations, [:text, :locale], name: :index_translations_uniqueness)
  end
  
  def down do
    drop index(:examples, [:sentence_id, :translation_id], name: :index_examples_uniqueness)
    drop index(:sentences, [:original, :locale], name: :index_sentences_uniqueness)
    drop index(:translations, [:text, :locale], name: :index_translations_uniqueness)
  end
end
