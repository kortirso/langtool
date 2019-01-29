defmodule Langtool.Factory do
  use ExMachina.Ecto, repo: Langtool.Repo
  use Langtool.UserFactory
  use Langtool.SessionFactory
  use Langtool.TaskFactory
  use Langtool.PositionFactory
  use Langtool.SentenceFactory
  use Langtool.TranslationFactory
  use Langtool.ExampleFactory
  use Langtool.RatingFactory
end
