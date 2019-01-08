defmodule LangtoolWeb.UserPolicy do
  alias Langtool.Accounts.User

  def index?(%User{role: "admin"}, _), do: true
  def index?(_, _), do: false

  def show?(user, object), do: index?(user, object)

  def edit?(user, object), do: index?(user, object)

  def update?(user, object), do: index?(user, object)

  def delete?(user, object), do: index?(user, object)
end
