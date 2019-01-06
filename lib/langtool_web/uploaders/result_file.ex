defmodule Langtool.ResultFile do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(_version, {_, task}) do
    if Mix.env == :test do
      "uploads/test/#{task.id}/result/#{task.session_id}"
    else
      "uploads/#{task.id}/result/#{task.session_id}"
    end
  end
end
