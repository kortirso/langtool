defmodule LangtoolWeb.TasksController do
  use LangtoolWeb, :controller
  alias Langtool.{Task, Repo}
  alias I18nParser.Detection

  def create(conn, %{"task" => task_params}) do
    changeset = Task.changeset(%Task{}, task_params)

    case Repo.insert(changeset) do
      {:ok, _task} ->
        json(conn, %{success: "Task is created"})
      {:error, _changeset} ->
        json(conn, %{success: "Task is not created"})
    end
  end

  def detection(conn, %{"file" => %Plug.Upload{filename: filename, path: path}}) do
    extension = filename |> String.split(".") |> Enum.at(-1)
    case Detection.detect(path, extension) do
      {:ok, message} ->
        json(conn, message)
      {:error, message} ->
        json(conn, %{error: message})
      true ->
        json(conn, %{error: "Unknown error"})
    end
  end
end
