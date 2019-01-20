defmodule LangtoolWeb.ExamplesController do
  use LangtoolWeb, :controller
  alias Langtool.{Examples, Sentences}

  plug :check_auth when action in [:create]
  plug :check_confirmation when action in [:create]

  def create(conn, %{"example" => %{"sentence_id" => sentence_id, "text" => text, "to" => to}}) do
    authorize(conn, :translation, :update?, nil)

    case Examples.create_example(String.to_integer(sentence_id), text, to) do
      {:ok, example} ->
        render(conn, "create.json", sentence: Sentences.get_from_example(example))
      {:error, _} ->
        json(conn, %{error: "Creating error"})
    end
  end
end
