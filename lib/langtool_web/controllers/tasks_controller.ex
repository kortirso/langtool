defmodule LangtoolWeb.TasksController do
  use LangtoolWeb, :controller
  alias Langtool.Tasks
  alias LangtoolWeb.RoomChannel

  plug :check_auth when action in [:index, :show, :delete]
  plug :check_confirmation when action in [:index, :show, :delete]

  def index(conn, _) do
    conn
    |> assign(:tasks, Tasks.get_tasks_for_user(conn.assigns.current_user))
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task_with_positions(String.to_integer(id))
    authorize(conn, :task, :show?, task)

    conn
    # |> assign(:task, task)
    |> render("show.html")
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        case Tasks.attach_file(task, task_params) do
          {:ok, task} ->
            Langtool.HandleTaskSupervisor.handle_task(task)
            RoomChannel.broadcast_new_task(task)
            json(conn, %{success: "Task is created"})
          _ ->
            json(conn, %{success: "Task is not created"})
        end
      {:error, _} ->
        json(conn, %{success: "Task is not created"})
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task(String.to_integer(id))
    authorize(conn, :task, :delete?, task)
    {:ok, _} = Tasks.delete_task(task)

    conn
    |> put_flash(:success, "Task deleted successfully.")
    |> redirect(to: tasks_path(conn, :index))
  end

  def detection(conn, %{"file" => %Plug.Upload{filename: filename, path: path}}) do
    case Tasks.detect_locale(filename, path) do
      {:ok, message} ->
        json(conn, message)
      {:error, message} ->
        json(conn, %{error: message})
      _ ->
        json(conn, %{error: "Unknown error"})
    end
  end
end
