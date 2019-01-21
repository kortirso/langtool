defmodule Langtool.Tasks.Task do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset
  alias Langtool.{Tasks.Task, Positions.Position, Sessions.Session}

  schema "tasks" do
    field :file, Langtool.File.Type
    field :result_file, Langtool.ResultFile.Type
    field :from, :string
    field :status, :string
    field :to, :string

    belongs_to :session, Session

    has_many :positions, Position, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def create_changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:session_id, :from, :to, :status])
    |> assoc_constraint(:session)
    |> validate_required([:from, :to, :status])
    |> validate_inclusion(:status, ["created", "active", "failed", "completed"])
    |> validate_length(:from, min: 2)
    |> validate_length(:to, min: 2)
  end

  def file_changeset(%Task{} = task, attrs) do
    task
    |> cast_attachments(attrs, [:file], [])
    |> validate_required([:file])
  end

  def result_file_changeset(%Task{} = task, attrs) do
    task
    |> cast_attachments(attrs, [:result_file], [])
    |> validate_required([:result_file])
  end

  def localizator_changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:status])
    |> validate_inclusion(:status, ["created", "active", "failed", "completed"])
  end
end
