defmodule LangtoolWeb.RoomChannel do
  use Phoenix.Channel

  def join("room:" <> _private_room_id, _message, socket) do
    {:ok, socket}
  end

  def broadcast_new_task(task) do
    payload = %{
      id: task.id,
      from: task.from,
      to: task.to,
      status: task.status,
      file: task.file
    }
    LangtoolWeb.Endpoint.broadcast("room:#{task.user_session_id}", "new_task", payload)
  end

  def broadcast_completed_task(task) do
    payload = %{
      id: task.id,
      status: task.status
    }
    LangtoolWeb.Endpoint.broadcast("room:#{task.user_session_id}", "complete_task", payload)
  end
end
