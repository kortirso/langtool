defmodule Langtool.TranslationFactory do
  alias Langtool.Translations.Translation

  defmacro __using__(_opts) do
    quote do
      def translation_factory do
        %Translation{
          source: "yandex",
          text: "Hola",
          locale: "es"
        }
      end
    end
  end
end
