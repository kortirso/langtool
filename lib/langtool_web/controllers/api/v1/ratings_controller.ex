defmodule LangtoolWeb.Api.V1.RatingsController do
  use LangtoolWeb, :controller
  alias Langtool.{Ratings, Translations}

  plug :api_check_auth when action in [:create]
  plug :api_check_confirmation when action in [:create]

  def create(conn, %{"rating" => rating_params}) do
    rating_params
    |> Map.merge(%{"user_id" => conn.assigns.current_user.id})
    |> Ratings.create_rating()
    |> case do
      {:ok, rating} ->
        case Translations.update_rating(rating) do
          {:ok, translation} -> render(conn, "create.json", translation: translation)
          {:error, _} -> render_error(conn, 409, "Translation updating error")
        end
      {:error, _} -> render_error(conn, 409, "Rating creation error")
    end
  end

  defp render_error(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(LangtoolWeb.ErrorView)
    |> render("#{status}.json", message: message)
  end
end
