defmodule LangtoolWeb.Api.V1.PositionsController do
  use LangtoolWeb, :controller
  alias Langtool.Positions

  plug :api_check_auth when action in [:update]
  plug :api_check_confirmation when action in [:update]

  def update(conn, %{"id" => id, "position" => position_params}) do
    position = Positions.get_position(String.to_integer(id))
    authorize(conn, :position, :update?, position)

    case Positions.update_position(position, position_params) do
      {:ok, position} -> render(conn, "update.json", position: position)
      {:error, _} -> render_error(conn, 409, "Position updating error")
    end
  end

  defp render_error(conn, status, message) do
    conn
    |> put_status(status)
    |> put_view(LangtoolWeb.ErrorView)
    |> render("#{status}.json", message: message)
  end
end
