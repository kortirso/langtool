defmodule LangtoolWeb.UserPolicy do
  def index?("admin", _), do: true
  def index?(_, _), do: true

  def show?("admin", _), do: true
  def show?(_, _), do: false

  def edit?("admin", _), do: true
  def edit?(_, _), do: false

  def delete?("admin", _), do: true
  def delete?(_, _), do: false
end
