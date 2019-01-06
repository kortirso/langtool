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
          |> redirect(to: welcome_path(conn, :index))
          |> halt()
        end
      end

      defp authorize(conn, policy, action, object) do
        current_user = conn.assigns.current_user
        if do_authorize(current_user, policy, action, object) do
          conn
        else
          conn
          |> put_flash(:danger, "Forbidden.")
          |> redirect(to: welcome_path(conn, :index))
          |> halt()
        end
      end

      defp do_authorize(current_user, policy, action, object) do
        policy
        |> define_policy_action()
        |> apply(action, [current_user, object])
      end

      defp define_policy_action(policy) do
        :"Elixir.LangtoolWeb.#{String.capitalize(to_string(policy))}Policy"
      end
    end
  end
end
