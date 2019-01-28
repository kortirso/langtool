defmodule LangtoolWeb.Authorize do
  @moduledoc """
  A module providing authorization functions
  """

  defmacro __using__(_opts) do
    quote do
      defp authorize(conn, policy, action, object \\ nil) do
        current_user = conn.assigns.current_user
        if do_authorize(current_user, policy, action, object) do
          conn
        else
          render_auth_error(conn, "Forbidden.")
        end
      end

      defp do_authorize(current_user, policy, action, object) do
        policy
        |> define_policy_action()
        |> apply(action, [current_user, object])
      end

      defp define_policy_action(policy) do
        policy_name = policy |> to_string() |> String.capitalize()

        :"Elixir.LangtoolWeb.#{policy_name}Policy"
      end
    end
  end
end
