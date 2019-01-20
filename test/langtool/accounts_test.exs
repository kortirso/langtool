defmodule Langtool.AccountsTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Accounts, Accounts.User}

  setup [:create_users]

  @user_params %{
    email: "something@gmail.com",
    encrypted_password: "1234567890",
    role: "user"
  }

  @invalid_user_params %{
    email: "something@gmail.com",
    encrypted_password: "",
    role: "user"
  }

  test "get_users, returns all users", %{user1: user1, user2: user2} do
    result = Accounts.get_users()

    assert is_list(result) == true
    assert length(result) == 2
    assert Enum.at(result, 0) == user1
    assert Enum.at(result, 1) == user2
  end

  describe ".get_user" do
    test "returns user for existed id", %{user1: user1} do
      assert user1 == Accounts.get_user(user1.id)
    end

    test "returns nil for unexisted id", %{user1: user1, user2: user2} do
      assert nil == Accounts.get_user(user1.id + user2.id)
    end
  end

  describe ".get_user_by" do
    test "returns user for existed params", %{user1: user1} do
      assert user1 == Accounts.get_user_by(%{email: user1.email})
    end

    test "returns nil for unexisted params" do
      assert nil == Accounts.get_user_by(%{email: "something@gmail.com"})
    end
  end

  describe ".create_user" do
    test "creates user for valid params" do
      assert {:ok, %User{}} = Accounts.create_user(@user_params)
    end

    test "does not create user for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_user_params)
    end
  end

  describe ".update_user" do
    test "updates user for valid params", %{user1: user1} do
      assert {:ok, %User{}} = Accounts.update_user(user1, %{confirmed_at: DateTime.utc_now})
    end

    test "does not update user for invalid params", %{user1: user1} do
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user1, %{role: "superadmin"})
    end
  end

  describe ".delete_user" do
    test "deletes user for existed user", %{user1: user1} do
      assert {:ok, %User{}} = Accounts.delete_user(user1)
    end
  end

  describe ".change_user" do
    test "returns changeset", %{user1: user1} do
      assert %Ecto.Changeset{data: %User{}} = Accounts.change_user(user1)
    end
  end

  describe ".confirm_user" do
    test "returns error for unexisted user" do
      assert {:error, "User is not found for confirmation"} = Accounts.confirm_user("something", "something")
    end

    test "returns error for invalid token", %{user1: user1} do
      assert {:error, "Confirmation token is invalid"} = Accounts.confirm_user(user1.email, "something")
    end

    test "returns error for confirmed email", %{user1: user1} do
      {:ok, user} = Accounts.update_user(user1, %{confirmed_at: DateTime.utc_now})

      assert {:error, "Email is already confirmed"} = Accounts.confirm_user(user.email, user.confirmation_token)
    end

    test "returns user after successful confirmation", %{user1: user1} do
      assert {:ok, %User{confirmed_at: confirmed_at}} = Accounts.confirm_user(user1.email, user1.confirmation_token)
      assert confirmed_at != nil
    end
  end

  defp create_users(_) do
    user1 = insert(:user)
    user2 = insert(:user)
    {:ok, user1: user1, user2: user2}
  end
end