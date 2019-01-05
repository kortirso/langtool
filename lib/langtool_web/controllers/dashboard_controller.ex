defmodule LangtoolWeb.DashboardController do
  use LangtoolWeb, :controller

  def index(conn, _) do
    render conn, "index.html"
  end
end
