defmodule LangtoolWeb.SentencesView do
  use LangtoolWeb, :view

  def render("index.json", %{sentences: sentences, locale: locale}) do
    %{
      sentences: Enum.map(sentences, &sentence_json(&1, locale))
    }
  end

  defp sentence_json(sentence, locale) do
    %{
      id: sentence.id,
      original: sentence.original,
      key: "#{sentence.id}-#{locale}",
      translations: Enum.map(sentence.translations, &translation_json/1)
    }
  end

  defp translation_json(translation) do
    %{
      id: translation.id,
      text: translation.text
    }
  end
end