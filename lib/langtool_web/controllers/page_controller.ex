defmodule LangtoolWeb.PageController do
  use LangtoolWeb, :controller
  alias Langtool.{Sessions}

  def index(conn, _) do
    user_session_id = get_session(conn, :user_session_id)
    conn
    |> assign(:tasks, Sessions.load_tasks(user_session_id))
    |> render("index.html")
  end
end
