defmodule Langtool.SessionsTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Sessions, Sessions.Session, Accounts.User, Tasks.Task}

  setup [:create_session]

  describe ".get_session" do
    test "returns session for existed id", %{session: session} do
      assert %Session{id: session_id} = Sessions.get_session(session.id)
      assert session_id == session.id
    end

    test "returns nil for unexisted id", %{session: session} do
      assert nil == Sessions.get_session(session.id + 1)
    end
  end

  describe ".get_session_with_user" do
    test "returns session for existed id", %{session: session} do
      assert result = Sessions.get_session_with_user(session.id)
      assert result.id == session.id
      assert %User{} = result.user
    end

    test "returns nil for unexisted id", %{session: session} do
      assert nil == Sessions.get_session_with_user(session.id + 1)
    end
  end

  describe ".create_session" do
    test "creates session for valid params" do
      assert {:ok, %Session{}} = Sessions.create_session()
    end

    test "does not create session for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Sessions.create_session(%{user_id: 999})
    end
  end

  describe ".update_session" do
    test "updates session for valid params", %{session: session, user: user} do
      assert {:ok, %Session{}} = Sessions.update_session(session, %{user_id: user.id})
    end

    test "does not update session for invalid params", %{session: session} do
      assert {:error, %Ecto.Changeset{}} = Sessions.update_session(session, %{user_id: 999})
    end
  end

  describe ".attach_user" do
    test "attaches user for valid params", %{session: session, user: user} do
      assert {:ok, %Session{}} = Sessions.attach_user(session.id, user)
    end

    test "does not attach user for invalid params", %{user: user} do
      assert nil == Sessions.attach_user(999, user)
    end
  end

  describe ".load_tasks" do
    test "returns tasks for session owner", %{session: session, task: task} do
      result = Sessions.load_tasks(session.id)

      assert is_list(result) == true
      assert length(result) == 1
      assert %Task{id: task_id} = Enum.at(result, 0)
      assert task_id == task.id
    end

    test "returns nil for invalid owner" do
      assert [] = Sessions.load_tasks(999)
    end
  end

  defp create_session(_) do
    session = insert(:session)
    user = insert(:user)
    task = insert(:task, session: session)
    {:ok, session: session, user: user, task: task}
  end
end
