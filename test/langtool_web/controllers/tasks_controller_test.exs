defmodule LangtoolWeb.TasksControllerTest do
  use LangtoolWeb.ConnCase
  alias Langtool.{Sessions}

  @task_params %{
    file: %Plug.Upload{path: "test/fixtures/ru.yml", filename: "ru.yml"},
    from: "en",
    to: "ru",
    _csrf_token: "1234567890",
    status: "created"
  }

  @invalid_task_params %{
    file: %Plug.Upload{path: "test/fixtures/ru.yml", filename: "ru.yml"},
    from: "",
    to: "",
    _csrf_token: "1234567890",
    status: "created"
  }

  describe "POST /tasks" do
    setup [:create_session]

    test "Creates task for valid params", %{conn: conn, session: session} do
      conn = post conn, "/tasks", [task: Map.merge(@task_params, %{session_id: session.id})]

      assert json_response(conn, 200) == %{"success" => "Task is created"}
    end

    test "Does not create task for invalid params", %{conn: conn, session: session} do
      conn = post conn, "/tasks", [task: Map.merge(@invalid_task_params, %{session_id: session.id})]

      assert json_response(conn, 200) == %{"success" => "Task is not created"}
    end
  end

  describe "POST /tasks/detection" do
    test "Returns code and name of locale", %{conn: conn} do
      path = File.cwd! |> Path.join("test/fixtures/ru.yml")
      conn = post conn, "/tasks/detection", [file: %Plug.Upload{path: path, filename: "ru.yml"}]

      assert json_response(conn, 200) == %{"code" => "ru"}
    end

    test "Returns error message for invalid file", %{conn: conn} do
      path = File.cwd! |> Path.join("test/fixtures/invalid.yml")
      conn = post conn, "/tasks/detection", [file: %Plug.Upload{path: path, filename: "invalid.yml"}]

      assert json_response(conn, 200) == %{"error" => "Invalid amount of keys"}
    end
  end

  defp create_session(_) do
    {:ok, session} = Sessions.create_session()
    {:ok, session: session}
  end
end
