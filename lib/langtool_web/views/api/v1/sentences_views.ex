defmodule LangtoolWeb.Api.V1.SentencesView do
  use LangtoolWeb, :view
  alias Langtool.Accounts.User

  def render("index.json", %{sentences: sentences, locale: locale}) do
    %{
      sentences: Enum.map(sentences, &sentence_json(&1, locale))
    }
  end

  def render("translations.json", %{translations: translations}) do
    %{
      translations: Enum.map(translations, &translation_json/1)
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
      text: translation.text,
      editor: editor(translation.user)
    }
  end

  defp editor(nil), do: "/images/yandex.png"
  defp editor(user), do: User.avatar(user)
end