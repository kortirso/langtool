defmodule LangtoolWeb.SessionController do
  use LangtoolWeb, :controller
  alias Langtool.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:success, "Signed out successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end