defmodule LangtoolWeb.TranslationPolicy do
  alias Langtool.Accounts.User

  def index?(%User{role: "admin"}, _), do: true
  def index?(%User{role: "editor"}, _), do: true
  def index?(_, _), do: false
end
