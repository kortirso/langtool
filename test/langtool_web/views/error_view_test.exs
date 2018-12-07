defmodule LangtoolWeb.ErrorViewTest do
  use LangtoolWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(LangtoolWeb.ErrorView, "404.html", []) =~ "Sorry, the page you are looking for does not exist."
  end

  test "renders 500.html" do
    assert render_to_string(LangtoolWeb.ErrorView, "500.html", []) =~ "Sorry, internal server error is happened"
  end
end
