defmodule LangtoolWeb.Api.V1.TasksView do
  use LangtoolWeb, :view

  def render("show.json", %{positions: positions}) do
    %{
      positions: Enum.map(positions, &position_json/1)
    }
  end

  defp position_json(position) do
    %{
      id: position.id,
      index: position.index,
      result: position.result,
      sentence: sentence_json(position.sentence)
    }
  end

  defp sentence_json(sentence) do
    %{
      id: sentence.id,
      original: sentence.original
    }
  end
end