defmodule LangtoolWeb.Auth do
  @moduledoc """
  A module providing auth functions
  """

  alias Langtool.{Accounts}

  defmacro __using__(_opts) do
    quote do
      defp check_auth(conn, _) do
        if user_id = get_session(conn, :current_user_id) do
          current_user = Accounts.get_user!(user_id)
          assign(conn, :current_user, current_user)
        else
          conn
          |> put_flash(:danger, "You need to be signed in to access that page.")
          |> redirect(to: page_path(conn, :index))
          |> halt()
        end
      end
    end
  end
end
