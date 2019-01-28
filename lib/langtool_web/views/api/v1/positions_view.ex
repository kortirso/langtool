defmodule LangtoolWeb.Api.V1.PositionsView do
  use LangtoolWeb, :view

  def render("update.json", %{position: position}) do
    %{
      position: position_json(position)
    }
  end

  defp position_json(position) do
    %{
      id: position.id,
      index: position.index,
      result: position.result
    }
  end
end