defmodule LangtoolWeb.TranslationsController do
  use LangtoolWeb, :controller

  plug :check_auth when action in [:index]
  plug :check_confirmation when action in [:index]

  def index(conn, _) do
    conn
    |> authorize(:translation, :index?, nil)
    |> render("index.html")
  end
end
