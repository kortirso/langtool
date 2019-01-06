defmodule Langtool.Positions.Position do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Tasks.Task, Sentences.Sentence}

  schema "positions" do
    field :index, :integer
    field :result, :string

    belongs_to :task, Task
    belongs_to :sentence, Sentence

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, [:task_id, :index, :result, :sentence_id])
    |> validate_required([:index])
    |> assoc_constraint(:task)
    |> assoc_constraint(:sentence)
  end
end
