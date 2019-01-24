defmodule LangtoolWeb.ExamplesController do
  use LangtoolWeb, :controller
  alias Langtool.{Examples}

  plug :check_auth when action in [:create]
  plug :check_confirmation when action in [:create]

  def create(conn, %{"example" => %{"sentence_id" => sentence_id, "text" => text, "to" => to}, "reverse" => reverse}) do
    authorize(conn, :translation, :update?)

    case Examples.create_example_for_sentence(String.to_integer(sentence_id), text, to, reverse == "true") do
      {:ok, translation} -> render(conn, "create.json", translation: translation)
      {:error, _} -> json(conn, %{error: "Creating error"})
    end
  end
end
