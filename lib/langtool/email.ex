defmodule Langtool.Email do
  use Bamboo.Phoenix, view: LangtoolWeb.EmailView

  def render_email(name, type, email_address) do
    case name do
      "welcome_email" -> welcome_email(type, email_address)
      _ -> welcome_email(type, email_address)
    end
  end

  defp welcome_email(type, email_address) do
    email = prepare_email(email_address)
    case type do
      "text" -> welcome_email_text(email)
      _ -> welcome_email_html(email)
    end
  end

  defp prepare_email(email_address) do
    new_email()
    |> to(email_address)
    |> from("support@langtool.pro")
    |> subject("Welcome!")
  end

  def welcome_email_text(email) do
    email
    |> put_text_layout({LangtoolWeb.LayoutView, "email.text"})
    |> render("welcome.text")
    |> premail("text")
  end

  def welcome_email_html(email) do
    email
    |> put_html_layout({LangtoolWeb.LayoutView, "email.html"})
    |> render("welcome.html")
    |> premail("html")
  end

  defp premail(%Bamboo.Email{} = email, type) do
    html_body(email, Premailex.to_text(email_body(email, type)))
  end

  defp email_body(email, type) do
    case type do
      "text" -> email.text_body
      _ -> email.html_body
    end
  end
end
