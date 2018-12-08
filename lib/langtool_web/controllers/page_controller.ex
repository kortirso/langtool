defmodule LangtoolWeb.PageController do
  use LangtoolWeb, :controller
  alias Langtool.Tasks

  def index(conn, _params) do
    user_session_id = get_session(conn, :user_session_id)
    conn
    |> assign(:tasks, Tasks.last_for_user(user_session_id))
    |> render("index.html")
  end
end
