defmodule Langtool.SentenceFactory do
  alias Langtool.Sentences.Sentence

  defmacro __using__(_opts) do
    quote do
      def sentence_factory do
        %Sentence{
          original: "Hello",
          locale: "en"
        }
      end
    end
  end
end
