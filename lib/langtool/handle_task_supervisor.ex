defmodule Langtool.HandleTaskSupervisor do
  def handle_task(task) do
    opts = [restart: :temporary]
    Task.Supervisor.start_child(__MODULE__, LangtoolWeb.Jobs.HandleTaskJob, :perform, [task], opts)
  end
end
