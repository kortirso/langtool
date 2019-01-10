defmodule LangtoolWeb.SentencesView do
  use LangtoolWeb, :view

  def render("index.json", %{sentences: sentences}) do
    %{
      sentences: Enum.map(sentences, &sentence_json/1)
    }
  end

  defp sentence_json(sentence) do
    %{
      id: sentence.id,
      original: sentence.original,
      translations: Enum.map(sentence.translations, &translation_json/1)
    }
  end

  defp translation_json(translation) do
    %{
      id: translation.id,
      text: translation.text,
      source: translation.source,
    }
  end
end