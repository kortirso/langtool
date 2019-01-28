defmodule LangtoolWeb.Api.V1.SentencesController do
  use LangtoolWeb, :controller
  alias Langtool.Sentences

  plug :api_check_auth when action in [:index, :translations]
  plug :api_check_confirmation when action in [:index, :translations]

  def index(conn, %{"from" => from, "to" => to}) do
    conn
    |> authorize(:translation, :index?)
    |> render("index.json", sentences: Sentences.list_sentences(from, to), locale: to)
  end

  def translations(conn, %{"id" => sentence_id, "to" => to}) do
    translations = Sentences.list_translations(sentence_id, to)

    render(conn, "translations.json", translations: translations)
  end
end
