defmodule LangtoolWeb.Api.V1.RatingsView do
  use LangtoolWeb, :view

  def render("create.json", %{translation: translation}) do
    %{
      translation: translation_json(translation)
    }
  end

  defp translation_json(translation) do
    %{
      total_rating: translation.total_rating
    }
  end
end