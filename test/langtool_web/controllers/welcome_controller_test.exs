defmodule LangtoolWeb.WelcomeControllerTest do
  use LangtoolWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"

    assert html_response(conn, 200) =~ "LangTool!"
  end
end
