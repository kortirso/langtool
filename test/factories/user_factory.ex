defmodule Langtool.UserFactory do
  alias Langtool.Accounts.User

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %User{
          email: sequence(:email, &"email-#{&1}@example.com"),
          role: sequence(:role, ["user", "editor", "admin"]),
          encrypted_password: "1234567890"
        }
      end
    end
  end
end
