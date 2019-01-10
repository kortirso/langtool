defmodule LangtoolWeb.SentencesController do
  use LangtoolWeb, :controller
  alias Langtool.{Sentences}

  plug :check_auth when action in [:index]
  plug :check_confirmation when action in [:index]

  def index(conn, %{"from" => from, "to" => to}) do
    conn
    |> authorize(:translation, :index?, nil)
    |> render("index.json", sentences: Sentences.list_sentences(from, to))
  end
end
