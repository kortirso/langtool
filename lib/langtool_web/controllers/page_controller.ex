defmodule LangtoolWeb.PageController do
  use LangtoolWeb, :controller
  import Ecto.Query
  alias Langtool.{Task, Repo}

  def index(conn, _params) do
    {conn, user_session_id} = conn |> check_user_session_id()
    conn
    |> assign(:user_session_id, user_session_id)
    |> assign(:tasks, Repo.all(from task in Task, where: task.user_session_id == ^user_session_id) |> Enum.sort(&(&1.id >= &2.id)) |> Enum.take(-5))
    |> render("index.html")
  end

  defp check_user_session_id(conn) do
    conn
    |> get_session(:user_session_id)
    |> define_user_session_id(conn)
  end

  defp define_user_session_id(user_session_id, conn) when user_session_id == nil do
    user_session_id = random_string(24)
    conn = conn |> put_session(:user_session_id, user_session_id)
    {conn, user_session_id}
  end

  defp define_user_session_id(user_session_id, conn) do
    {conn, user_session_id}
  end

  defp random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
