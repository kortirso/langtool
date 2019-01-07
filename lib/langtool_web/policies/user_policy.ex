defmodule LangtoolWeb.UserPolicy do
  def index?("admin", _), do: true
  def index?(_, _), do: true
end
