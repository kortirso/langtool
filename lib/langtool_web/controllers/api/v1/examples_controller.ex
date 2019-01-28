defmodule LangtoolWeb.Api.V1.ExamplesController do
  use LangtoolWeb, :controller
  alias Langtool.Examples

  plug :api_check_auth when action in [:create]
  plug :api_check_confirmation when action in [:create]

  def create(conn, %{"example" => %{"sentence_id" => sentence_id, "text" => text, "to" => to}, "reverse" => reverse}) do
    authorize(conn, :translation, :update?)

    case Examples.create_example_for_sentence(String.to_integer(sentence_id), text, to, reverse == "true", conn.assigns.current_user.id) do
      {:ok, translation} -> render(conn, "create.json", translation: translation)
      {:error, _} -> render_error(conn, 409, "Example creation error")
    end
  end

  defp render_error(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(LangtoolWeb.ErrorView)
    |> render("#{status}.json", message: message)
  end
end
