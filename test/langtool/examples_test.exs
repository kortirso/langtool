defmodule Langtool.ExamplesTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Examples, Examples.Example}

  setup [:create_example]

  describe ".get_example_by" do
    test "returns example for existed params", %{example: example} do
      result = Examples.get_example_by(%{translation_id: example.translation_id, sentence_id: example.sentence_id})

      assert result.id == example.id
    end

    test "returns nil for unexisted params", %{example: example, sentence: sentence} do
      assert nil == Examples.get_example_by(%{translation_id: example.translation_id, sentence_id: sentence.id})
    end
  end

  describe ".create_example" do
    test "creates example for valid params", %{translation: translation, sentence: sentence} do
      assert {:ok, %Example{}} = Examples.create_example(%{translation_id: translation.id, sentence_id: sentence.id})

      # and does not create duplicate example
      assert {:error, %Ecto.Changeset{}} = Examples.create_example(%{translation_id: translation.id, sentence_id: sentence.id})
    end
  end

  describe ".create_or_find_example_by" do
    test "creates example for valid params", %{translation: translation, sentence: sentence} do
      example = Examples.create_or_find_example_by(%{translation_id: translation.id, sentence_id: sentence.id})

      assert %Example{} = example

      # and does not create duplicate example
      assert example = Examples.create_or_find_example_by(%{translation_id: translation.id, sentence_id: sentence.id})
    end
  end

  defp create_example(_) do
    translation = insert(:translation, text: "Hello", locale: "en")
    sentence = insert(:sentence, original: "Hola", locale: "es")
    example = insert(:example)
    {:ok, example: example, translation: translation, sentence: sentence}
  end
end