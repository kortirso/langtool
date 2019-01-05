defmodule LangtoolWeb.PreviewEmailController do
  use LangtoolWeb, :controller
  alias Langtool.{Accounts.User}
  alias LangtoolWeb.{UserMailer}

  def show(conn, %{"name" => name, "type" => type}) do
    name
    |> build_email()
    |> render_email(conn, type)
  end

  defp build_email("welcome_email") do
    %User{email: "john.doe@example.com", confirmation_token: "1234567890"}
    |> UserMailer.welcome_email()
  end

  defp render_email(email, conn, type) do
    conn
    |> Plug.Conn.put_resp_content_type("text/html")
    |> send_resp(:ok, email_body(email, type))
  end

  defp email_body(email, type) do
    case type do
      "text" -> email.text_body
      _ -> email.html_body
    end
  end
end
