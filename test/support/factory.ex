defmodule Langtool.Factory do
  use ExMachina.Ecto, repo: Langtool.Repo
  use Langtool.UserFactory
end
