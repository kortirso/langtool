defmodule LangtoolWeb.TaskPolicy do
  alias Langtool.{Accounts.User, Tasks.Task, Sessions}

  def delete?(%User{role: "admin"}, _), do: true

  def delete?(%User{id: user_id}, %Task{session_id: session_id}) do
    session = Sessions.get_session(session_id)
    session.user_id == user_id
  end

  def delete?(_, _), do: false
end
