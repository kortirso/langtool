defmodule LangtoolWeb.SessionController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts, Sessions}

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session}) do
    user = Accounts.get_by_email(session["email"])
    case Comeonin.Bcrypt.check_pass(user, session["password"]) do
      # successful signin
      {:ok, user} ->
        # attach session to user
        conn |> get_session(:session_id) |> Sessions.attach_user(user.id)
        conn
        |> put_session(:current_user_id, user.id)
        |> put_flash(:success, "Signed in successfully.")
        |> redirect(to: page_path(conn, :index))
      # signin error
      _ ->
        conn
        |> put_flash(:danger, "Invalid credentials.")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:success, "Signed out successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end