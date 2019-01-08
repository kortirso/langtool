defmodule LangtoolWeb.UsersController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts, Accounts.User}

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
    |> authorize(:user, :show?, user)
    |> assign(:user, user)
    |> render("show.html")
  end

  def edit(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    authorize(conn, :user, :edit?, user)

    changeset = User.changeset(user, %{})
    conn
    |> assign(:user, user)
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)
    authorize(conn, :user, :update?, user)
    case Accounts.update_user(user, user_params) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "User updated successfully.")
        |> redirect(to: users_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:danger, render_errors(changeset))
        |> assign(:user, user)
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    authorize(conn, :user, :delete?, user)
    {:ok, _} = Accounts.delete_user(user)

    conn
    |> put_flash(:success, "User deleted successfully.")
    |> redirect(to: users_path(conn, :index))
  end
end
