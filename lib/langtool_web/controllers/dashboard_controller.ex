defmodule LangtoolWeb.DashboardController do
  use LangtoolWeb, :controller

  plug :check_auth when action in [:index]

  def index(conn, _) do
    render conn, "index.html"
  end
end
