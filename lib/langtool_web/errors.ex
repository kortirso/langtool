defmodule LangtoolWeb.Errors do
  @moduledoc """
  A module providing presenting validation errors in readable format
  """
  def render_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn
      {msg, opts} -> String.replace(msg, "%{count}", to_string(opts[:count]))
      msg -> msg
    end)
    |> Enum.map(fn {key, value} ->
      head = if key == :encrypted_password, do: "password", else: to_string(key)
      "#{String.capitalize(head)} #{Enum.at(value, 0)}"
    end)
  end
end
