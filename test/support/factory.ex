defmodule Langtool.Factory do
  use ExMachina.Ecto, repo: Langtool.Repo
  use Langtool.UserFactory
  use Langtool.SessionFactory
  use Langtool.TaskFactory
  use Langtool.PositionFactory
  use Langtool.SentenceFactory
end
