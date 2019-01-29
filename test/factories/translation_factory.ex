defmodule Langtool.TranslationFactory do
  alias Langtool.Translations.Translation

  defmacro __using__(_opts) do
    quote do
      def translation_factory do
        %Translation{
          text: "Hola",
          locale: "es",
          total_rating: 0
        }
      end
    end
  end
end
