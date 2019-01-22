defmodule Langtool.ExampleFactory do
  alias Langtool.Examples.Example

  defmacro __using__(_opts) do
    quote do
      def example_factory do
        %Example{
          translation: build(:translation),
          sentence: build(:sentence)
        }
      end
    end
  end
end
