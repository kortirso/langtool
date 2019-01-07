defmodule Langtool.Positions do
  @moduledoc """
  The Positions context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Positions.Position}

  @doc """
  Create new position

  ## Examples

      iex> create_position(task_id, index, text, sentence_id)
      {:ok, %Position{}}

  """
  def create_position(task_id, index, text, sentence_id) do
    Repo.insert %Position{
      task_id: task_id,
      index: index,
      result: text,
      sentence_id: sentence_id
    }
  end
end
