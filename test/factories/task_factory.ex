defmodule Langtool.TaskFactory do
  alias Langtool.Tasks.Task

  defmacro __using__(_opts) do
    quote do
      def task_factory do
        %Task{
          from: "ru",
          to: "en",
          status: "created",
          session: build(:session)
        }
      end
    end
  end
end
