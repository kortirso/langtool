defmodule LangtoolWeb.DashboardController do
  use LangtoolWeb, :controller

  plug :check_auth when action in [:index]

  def index(conn, _) do
    conn
    |> authorize(:dashboard, :index?)
    |> render("index.html")
  end
end
