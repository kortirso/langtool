defmodule Langtool.PositionsTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Positions, Positions.Position}

  setup [:create_task]

  @position_params %{
    index: 0,
    result: "Hi"
  }

  describe ".create_position" do
    test "creates position for valid params", %{task: task, sentence: sentence} do
      assert {:ok, %Position{}} = @position_params |> Map.merge(%{task_id: task.id, sentence_id: sentence.id}) |> Positions.create_position()
    end

    test "does not create position for invalid params" do
      assert {:error, %Ecto.Changeset{}} = @position_params |> Map.merge(%{task_id: 999, sentence_id: 111}) |> Positions.create_position()
    end
  end

  defp create_task(_) do
    task = insert(:task)
    sentence = insert(:sentence)
    {:ok, task: task, sentence: sentence}
  end
end
