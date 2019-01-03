defmodule LangtoolWeb.PreviewEmailController do
  use LangtoolWeb, :controller
  alias Langtool.{Email}

  def show(conn, %{"name" => name, "type" => type}) do
    email = Email.render_email(name, type, "us@example.com")
    render_email(conn, email, type)
  end

  defp render_email(conn, email, type) do
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
