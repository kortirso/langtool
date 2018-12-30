defmodule Langtool.Position do
  use Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Tasks.Task, Sentence}

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
    |> cast(attrs, [:task_id, :index, :result])
    |> validate_required([:task_id, :index])
  end
end
