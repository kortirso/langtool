defmodule LangtoolWeb.UsersController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts}

  plug :check_auth
  plug :check_confirmation

  def index(conn, _) do
    conn
    |> authorize(:user, :index?, nil)
    |> assign(:users, Accounts.list_users())
    |> render("index.html")
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> assign(:user, user)
    |> authorize(:user, :show?, user)
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    conn
    |> assign(:user, user)
    |> authorize(:user, :edit?, user)
    |> render("edit.html")
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    authorize(conn, :user, :delete?, user)
    {:ok, _} = Accounts.delete_user(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: users_path(conn, :index))
  end
end
