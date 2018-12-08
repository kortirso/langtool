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
  def create_changeset(%Task{} = task, attrs) do
    task
    |> cast(attrs, [:user_session_id, :from, :to, :status])
    |> validate_required([:user_session_id, :from, :to, :status])
    |> validate_length(:from, min: 2)
    |> validate_length(:to, min: 2)
  end

  def avatar_changeset(%Task{} = task, attrs) do
    task
    |> cast_attachments(attrs, [:file], [])
    |> validate_required([:file])
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
