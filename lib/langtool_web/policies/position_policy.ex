defmodule LangtoolWeb.PositionPolicy do
  alias Langtool.{Accounts, Accounts.User, Tasks.Task, Positions.Position}

  def update?(%User{} = user, %Position{task_id: task_id}) do
    user = Accounts.get_user_with_tasks(user)

    user.tasks
    |> Enum.any?(fn %Task{id: id} -> id == task_id end)
  end

  def update?(_, _), do: false
end
