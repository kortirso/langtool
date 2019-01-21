defmodule Langtool.TasksTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Tasks, Tasks.Task}

  setup [:create_task]

  @task_params %{
    from: "en",
    to: "ru",
    status: "created"
  }

  @invalid_task_params %{
    from: "",
    to: "",
    status: "created"
  }

  @task_file_params %{
    file: %Plug.Upload{path: "test/fixtures/ru.yml", filename: "ru.yml"}
  }

  @task_invalid_file_params %{
    file: %Plug.Upload{path: "test/fixtures/invalid.yml", filename: "invalid.yml"}
  }

  test "get_tasks_for_user, returns all tasks", %{task: task} do
    result = Tasks.get_tasks_for_user(task.session.user)

    assert is_list(result) == true
    assert length(result) == 1
    assert %Task{id: task_id} = Enum.at(result, 0)
    assert task_id == task.id
  end

  describe ".get_task" do
    test "returns task for existed id", %{task: task} do
      assert %Task{id: task_id} = Tasks.get_task(task.id)
      assert task_id == task.id
    end

    test "returns nil for unexisted id", %{task: task} do
      assert nil == Tasks.get_task(task.id + 1)
    end
  end

  describe ".create_task" do
    test "creates task for valid params", %{session: session} do
      assert {:ok, %Task{}} = Tasks.create_task(Map.merge(@task_params, %{session_id: session.id}))
    end

    test "does not create task for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_task_params)
    end
  end

  describe ".update_task_status" do
    test "updates task status for valid params", %{task: task} do
      assert {:ok, %Task{}} = Tasks.update_task_status(task, "completed")
    end

    test "does not update task status for invalid params", %{task: task} do
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task_status(task, "processing")
    end
  end

  describe ".attach_file" do
    test "attaches file to task", %{task: task} do
      assert {:ok, task_with_file} = Tasks.attach_file(task, @task_file_params)
      assert task_with_file.file != nil
    end
  end

  describe ".detect_locale" do
    test "detects locale for valid file" do
      assert {:ok, %{code: "ru"}} = Tasks.detect_locale("ru.yml", @task_file_params.file.path)
    end

    test "does not detect locale for invalid file" do
      assert {:error, _} = Tasks.detect_locale("ru.yml", @task_invalid_file_params.file.path)
    end
  end

  describe ".delete_task" do
    test "deletes task for existed task", %{task: task} do
      assert {:ok, %Task{}} = Tasks.delete_task(task)
    end
  end

  defp create_task(_) do
    session = insert(:session)
    task = insert(:task)
    {:ok, task: task, session: session}
  end
end
