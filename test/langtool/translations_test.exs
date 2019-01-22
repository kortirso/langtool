defmodule Langtool.TranslationsTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Translations, Translations.Translation}

  setup [:create_translation]

  @translation_params %{
    text: "Hello",
    locale: "en"
  }

  @invalid_translation_params %{
    text: "",
    locale: ""
  }

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

  describe ".build_translation" do
    test "builds translation" do
      assert %Translation{} = Translations.build_translation(@translation_params)
    end
  end

  describe ".create_translation" do
    test "creates translation for valid params" do
      assert {:ok, %Translation{}} = Translations.create_translation(@translation_params)

      # and does not create duplicate translation
      assert {:error, %Ecto.Changeset{}} = Translations.create_translation(@translation_params)
    end

    test "does not create translation for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Translations.create_translation(@invalid_translation_params)
    end
  end

  describe ".create_translation_with_sentence" do
    test "creates translation for valid params", %{sentence: sentence} do
      assert {:ok, %Translation{}} = Translations.create_translation_with_sentence(@translation_params, sentence)

      # and does not create duplicate translation
      assert {:error, %Ecto.Changeset{}} = Translations.create_translation_with_sentence(@translation_params, sentence)
    end

    test "does not create translation for invalid params", %{sentence: sentence} do
      assert {:error, %Ecto.Changeset{}} = Translations.create_translation_with_sentence(@invalid_translation_params, sentence)
    end
  end

  describe ".create_or_find_translation_by" do
    test "creates translation for valid params" do
      translation = Translations.create_or_find_translation_by(@translation_params)

      assert %Translation{} = translation

      # and does not create duplicate translation
      assert translation = Translations.create_or_find_translation_by(@translation_params)
    end

    test "returns nil for invalid params" do
      assert nil == Translations.create_or_find_translation_by(@invalid_translation_params)
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
    sentence = insert(:sentence)
    {:ok, translation: translation, sentence: sentence}
  end
end