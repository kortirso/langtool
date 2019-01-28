defmodule LangtoolWeb.Auth do
  @moduledoc """
  A module providing auth functions
  """

  alias Langtool.{Accounts}

  defmacro __using__(_opts) do
    quote do
      defp check_auth(conn, _) do
        if user_id = get_session(conn, :current_user_id) do
          current_user = Accounts.get_user(user_id)
          assign(conn, :current_user, current_user)
        else
          render_auth_error(conn, "You need to be signed in to access that page.")
        end
      end

      defp check_confirmation(conn, _) do
        if conn.assigns.current_user.confirmed_at == nil do
          render_auth_error(conn, "You need to confirm your email.")
        else
          conn
        end
      end

      defp render_auth_error(conn, message) do
        conn
        |> put_flash(:danger, message)
        |> redirect(to: welcome_path(conn, :index))
        |> halt()
      end
    end
  end
end
