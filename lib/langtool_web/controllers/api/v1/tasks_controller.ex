defmodule LangtoolWeb.Api.V1.TasksController do
  use LangtoolWeb, :controller
  alias Langtool.Tasks

  plug :api_check_auth when action in [:show]
  plug :api_check_confirmation when action in [:show]

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task_with_positions(String.to_integer(id))
    authorize(conn, :task, :show?, task)

    render(conn, "show.json", task: task)
  end
end
