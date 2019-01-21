defmodule Langtool.SessionFactory do
  alias Langtool.Sessions.Session

  defmacro __using__(_opts) do
    quote do
      def session_factory do
        %Session{
          user: build(:user)
        }
      end
    end
  end
end
