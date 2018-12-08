defmodule LangtoolWeb.PageController do
  use LangtoolWeb, :controller
  alias Langtool.Tasks

  def index(conn, _params) do
    {conn, user_session_id} = check_user_session_id(conn)
    conn
    |> assign(:user_session_id, user_session_id)
    |> assign(:tasks, Tasks.last_for_user(user_session_id))
    |> render("index.html")
  end

  defp check_user_session_id(conn) do
    conn
    |> get_session(:user_session_id)
    |> define_user_session_id(conn)
  end

  defp define_user_session_id(nil, conn) do
    user_session_id = random_string(24)
    conn = put_session(conn, :user_session_id, user_session_id)
    {conn, user_session_id}
  end

  defp define_user_session_id(user_session_id, conn) do
    {conn, user_session_id}
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
