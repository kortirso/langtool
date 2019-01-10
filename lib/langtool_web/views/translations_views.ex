defmodule LangtoolWeb.TranslationsView do
  use LangtoolWeb, :view

  def render("update.json", %{translation: translation}), do: translation_json(translation)

  defp translation_json(translation) do
    %{
      id: translation.id,
      text: translation.text,
      source: translation.source,
    }
  end
end