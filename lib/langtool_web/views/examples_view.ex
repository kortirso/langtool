defmodule LangtoolWeb.ExamplesView do
  use LangtoolWeb, :view

  def render("create.json", %{translation: translation}) do
    %{
      translation: translation_json(translation)
    }
  end

  defp translation_json(translation) do
    %{
      id: translation.id,
      text: translation.text
    }
  end
end