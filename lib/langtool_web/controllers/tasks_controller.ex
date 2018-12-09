defmodule LangtoolWeb.TasksController do
  use LangtoolWeb, :controller
  alias Langtool.Tasks
  alias LangtoolWeb.RoomChannel

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        case Tasks.attach_file(task, task_params) do
          {:ok, task} ->
            Langtool.TaskHandleSupervisor.handle_task_file(task)
            RoomChannel.broadcast_new_task(task)
            json(conn, %{success: "Task is created"})
          _ ->
            json(conn, %{success: "Task is not created"})
        end
      {:error, _} ->
        json(conn, %{success: "Task is not created"})
    end
  end

  def detection(conn, %{"file" => %Plug.Upload{filename: filename, path: path}}) do
    case Tasks.detect_locale(filename, path) do
      {:ok, message} ->
        json(conn, message)
      {:error, message} ->
        json(conn, %{error: message})
      true ->
        json(conn, %{error: "Unknown error"})
    end
  end
end
