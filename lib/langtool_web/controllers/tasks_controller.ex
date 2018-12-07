defmodule LangtoolWeb.TasksController do
  use LangtoolWeb, :controller
  alias Langtool.Tasks
  alias I18nParser.Detection

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, _} ->
        json(conn, %{success: "Task is created"})
      {:error, _} ->
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
