defmodule Langtool.RatingFactory do
  alias Langtool.Ratings.Rating

  defmacro __using__(_opts) do
    quote do
      def rating_factory do
        %Rating{
          user: build(:user),
          translation: build(:translation),
          value: 1
        }
      end
    end
  end
end
