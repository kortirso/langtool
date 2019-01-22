defmodule Langtool.SentencesTest do
  use LangtoolWeb.ConnCase
  import Langtool.Factory
  alias Langtool.{Sentences, Sentences.Sentence}

  setup [:create_sentence]

  @sentence_params %{
    original: "Hola",
    locale: "es"
  }

  @invalid_sentence_params %{
    original: "",
    locale: ""
  }

  describe ".get_sentence" do
    test "returns sentence for existed id", %{sentence: sentence} do
      assert sentence == Sentences.get_sentence(sentence.id)
      assert is_list(sentence.translations) != true
    end

    test "returns nil for unexisted id", %{sentence: sentence} do
      assert nil == Sentences.get_sentence(sentence.id + 999)
    end
  end

  describe ".get_sentence_with_translations" do
    test "returns sentence for existed id", %{sentence: sentence} do
      result = Sentences.get_sentence_with_translations(sentence.id)

      assert is_list(result.translations) == true
    end

    test "returns nil for unexisted id", %{sentence: sentence} do
      assert nil == Sentences.get_sentence_with_translations(sentence.id + 999)
    end
  end

  describe ".get_sentence_by" do
    test "returns sentence for existed params", %{sentence: sentence} do
      assert sentence = Sentences.get_sentence_by(%{original: sentence.original, locale: sentence.locale})
      assert is_list(sentence.translations) != true
    end

    test "returns nil for unexisted params" do
      assert nil == Sentences.get_sentence_by(%{original: "Hi", locale: "es"})
    end
  end

  describe ".get_sentence_with_translations_by" do
    test "returns sentence for existed params", %{sentence: sentence} do
      result = Sentences.get_sentence_with_translations_by(%{original: sentence.original, locale: sentence.locale})

      assert is_list(result.translations) == true
    end

    test "returns nil for unexisted params" do
      assert nil == Sentences.get_sentence_with_translations_by(%{original: "Hi", locale: "es"})
    end
  end

  describe ".build_sentence" do
    test "builds sentence" do
      assert %Sentence{} = Sentences.build_sentence(@sentence_params)
    end
  end

  describe ".create_sentence" do
    test "creates sentence for valid params" do
      assert {:ok, %Sentence{}} = Sentences.create_sentence(@sentence_params)

      # and does not create duplicate sentence
      assert {:error, %Ecto.Changeset{}} = Sentences.create_sentence(@sentence_params)
    end

    test "does not create sentence for invalid params" do
      assert {:error, %Ecto.Changeset{}} = Sentences.create_sentence(@invalid_sentence_params)
    end
  end

  describe ".create_sentence_with_translation" do
    test "creates sentence for valid params", %{translation: translation} do
      assert {:ok, %Sentence{}} = Sentences.create_sentence_with_translation(@sentence_params, translation)

      # and does not create duplicate sentence
      assert {:error, %Ecto.Changeset{}} = Sentences.create_sentence_with_translation(@sentence_params, translation)
    end

    test "does not create sentence for invalid params", %{translation: translation} do
      assert {:error, %Ecto.Changeset{}} = Sentences.create_sentence_with_translation(@invalid_sentence_params, translation)
    end
  end

  defp create_sentence(_) do
    sentence = insert(:sentence)
    translation = insert(:translation)
    {:ok, sentence: sentence, translation: translation}
  end
end