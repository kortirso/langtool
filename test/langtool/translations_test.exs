defmodule Langtool.TranslationsTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Translations, Translations.Translation}

  setup [:create_translation]

  describe ".get_translation" do
    test "returns translation for existed id", %{translation: translation} do
      assert translation == Translations.get_translation(translation.id)
    end

    test "returns nil for unexisted id", %{translation: translation} do
      assert nil == Translations.get_translation(translation.id + 999)
    end
  end

  describe ".get_translation_by" do
    test "returns translation for existed params", %{translation: translation} do
      assert translation == Translations.get_translation_by(%{text: translation.text, locale: translation.locale})
    end

    test "returns nil for unexisted params" do
      assert nil == Translations.get_translation_by(%{text: "something", locale: "fr"})
    end
  end

  describe ".update_translation" do
    test "updates translation for valid params", %{translation: translation} do
      assert {:ok, %Translation{}} = Translations.update_translation(translation, %{text: "New text"})
    end

    test "does not update translation for invalid params", %{translation: translation} do
      assert {:error, %Ecto.Changeset{}} = Translations.update_translation(translation, %{locale: nil})
    end
  end

  defp create_translation(_) do
    translation = insert(:translation)
    {:ok, translation: translation}
  end
end