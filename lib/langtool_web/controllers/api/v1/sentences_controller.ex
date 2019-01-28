defmodule LangtoolWeb.Api.V1.SentencesController do
  use LangtoolWeb, :controller
  alias Langtool.Sentences

  plug :api_check_auth when action in [:translations]
  plug :api_check_confirmation when action in [:translations]

  def translations(conn, %{"id" => sentence_id, "to" => to}) do
    translations = Sentences.list_translations(sentence_id, to)

    render(conn, "translations.json", translations: translations)
  end
end
