defmodule LangtoolWeb.UsersController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts}

  plug :check_auth when action in [:index]

  def index(conn, _) do
    conn
    |> authorize(:user, :index?, nil)
    |> assign(:users, Accounts.list_users())
    |> render("index.html")
  end
end
