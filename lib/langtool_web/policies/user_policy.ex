defmodule LangtoolWeb.UserPolicy do
  def index?("admin", _), do: true
  def index?(_, _), do: true

  def show?("admin", _), do: true
  def show?(_, _), do: true
end
