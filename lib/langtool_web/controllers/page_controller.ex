defmodule LangtoolWeb.PageController do
  use LangtoolWeb, :controller

  def index(conn, _params) do
    conn
    |> check_user_session_id()
    |> assign(:user_session_id, get_session(conn, :user_session_id))
    |> render("index.html")
  end

  defp check_user_session_id(conn) do
    message = conn |> get_session(:user_session_id)
    if message == nil, do: conn |> put_session(:user_session_id, random_string(24)), else: conn
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
