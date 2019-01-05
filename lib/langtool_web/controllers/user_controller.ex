defmodule LangtoolWeb.UserController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts, Accounts.User, Mailer}
  alias LangtoolWeb.{UserMailer}

  def new(conn, _) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      # user is created
      {:ok, user} ->
        user |> UserMailer.welcome_email() |> Mailer.deliver_later()
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
    |> put_flash(:success, "User created successfully.")
    |> render("complete.html")
  end

  def confirm(conn, %{"email" => email, "confirmation_token" => confirmation_token}) do
    case Accounts.confirm_user(email, confirmation_token) do
      {:ok, _} ->
        conn
        |> put_flash(:success, "Email confirmed successfully.")
        |> render("confirm.html")

      {:error, message} ->
        conn
        |> put_flash(:danger, message)
        |> render("confirm.html")
    end
  end
end
