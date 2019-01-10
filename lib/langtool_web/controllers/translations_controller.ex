defmodule LangtoolWeb.TranslationsController do
  use LangtoolWeb, :controller
  alias Langtool.{Translations}

  plug :check_auth when action in [:index, :update]
  plug :check_confirmation when action in [:index, :update]

  def index(conn, _) do
    conn
    |> authorize(:translation, :index?, nil)
    |> render("index.html")
  end

  def update(conn, %{"id" => id, "translation" => translation_params}) do
    translation = Translations.get_translation!(id)
    authorize(conn, :translation, :update?, translation)
    case Translations.update_translation(translation, translation_params) do
      {:ok, translation} -> render(conn, "update.json", translation: translation)
      {:error, _} -> json(conn, %{error: "Updating error"})
    end
  end
end
