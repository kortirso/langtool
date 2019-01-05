defmodule LangtoolWeb.DashboardController do
  use LangtoolWeb, :controller
  alias LangtoolWeb.{DashboardPolicy}

  plug :check_auth when action in [:index]

  def index(conn, _) do
    conn
    |> authorize(:dashboard, :index?, nil)
    |> render("index.html")
  end
end
