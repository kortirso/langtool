defmodule LangtoolWeb.UserController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts, Accounts.User, Email, Mailer}

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      # user is created
      {:ok, user} ->
        Email.render_email("welcome_email", "html", user.email) |> Mailer.deliver_now
        conn
        |> put_session(:current_user_id, user.id)
        |> put_status(201)
        |> json(%{success: "User is created"})
      # error in user creation
      {:error, changeset} ->
        errors = Enum.map(changeset.errors, fn {key, {error, _}} -> %{key => error} end)
        json(conn, errors)
    end
  end

  def complete(conn, _) do
    conn
    |> put_flash(:info, "User created successfully.")
    |> render("complete.html")
  end
end
