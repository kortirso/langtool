defmodule LangtoolWeb.Api.V1.SentencesView do
  use LangtoolWeb, :view

  def render("translations.json", %{translations: translations}) do
    %{
      translations: Enum.map(translations, &translation_json/1)
    }
  end

  defp translation_json(translation) do
    %{
      id: translation.id,
      source: translation.source,
      text: translation.text
    }
  end
end