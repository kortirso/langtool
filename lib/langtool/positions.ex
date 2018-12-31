defmodule Langtool.Positions do
  @moduledoc """
  The Positions context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Positions.Position, Sentences.Sentence, Translations.Translation, Tasks.Task}

  @doc """
  Create new position

  ## Examples

      iex> create_position(task, index, original, text)
      {:ok, %Position{}}

  """
  def create_position(%Task{id: task_id, from: from, to: to}, index, original, text) do
    Repo.insert %Position{
      task_id: task_id,
      index: index,
      result: text,
      sentence: %Sentence{
        original: original,
        locale: from,
        translations: [
          %Translation{source: "yandex", text: text, locale: to}
        ]
      }
    }
  end
end
