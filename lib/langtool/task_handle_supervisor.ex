defmodule Langtool.TaskHandleSupervisor do
  def handle_task_file(task) do
    opts = [restart: :temporary]
    Task.Supervisor.start_child(__MODULE__, Langtool.Tasks, :handle_task, [task], opts)
  end
end
