defmodule Langtool.Tasks.Task do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  alias Langtool.Tasks.Task

  schema "tasks" do
    field :file, Langtool.File.Type
    field :from, :string
    field :status, :string
    field :to, :string
    field :user_session_id, :string

    timestamps()
  end

  @doc false
  def changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:file, :user_session_id, :from, :to, :status])
    |> validate_required([:file, :user_session_id, :from, :to, :status])
    |> validate_length(:from, min: 2)
    |> validate_length(:to, min: 2)
  end
end
