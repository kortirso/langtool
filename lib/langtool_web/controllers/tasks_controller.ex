defmodule LangtoolWeb.TasksController do
  use LangtoolWeb, :controller
  alias Langtool.{Task, Repo}

  def create(conn, %{"task" => task_params}) do
    changeset = Task.changeset(%Task{}, task_params)

    case Repo.insert(changeset) do
      {:ok, task} ->
        json(conn, %{success: "Task is created"})
      {:error, changeset} ->
        json(conn, %{success: "Task is not created"})
    end
  end
end
