defmodule LangtoolWeb.UsersController do
  use LangtoolWeb, :controller

  plug :check_auth when action in [:index]

  def index(conn, _) do
    conn
    |> authorize(:user, :index?, nil)
    |> render("index.html")
  end
end
