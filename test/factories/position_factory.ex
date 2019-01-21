defmodule Langtool.PositionFactory do
  alias Langtool.Positions.Position

  defmacro __using__(_opts) do
    quote do
      def position_factory do
        %Position{
          index: 0,
          result: "something",
          task: build(:task),
          sentence: build(:sentence)
        }
      end
    end
  end
end
