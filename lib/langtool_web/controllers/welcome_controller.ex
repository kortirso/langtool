defmodule LangtoolWeb.WelcomeController do
  use LangtoolWeb, :controller
  alias Langtool.{Sessions}

  def index(conn, _) do
    session_id = get_session(conn, :session_id)

    conn
    |> assign(:tasks, Sessions.load_tasks(session_id))
    |> render("index.html")
  end
end
