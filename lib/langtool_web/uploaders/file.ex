defmodule Langtool.File do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def storage_dir(_version, {_, task}) do
    if Mix.env == :test do
      "uploads/test/#{task.id}/original/#{task.user_session_id}"
    else
      "uploads/#{task.id}/original/#{task.user_session_id}"
    end
  end

  def temp_storage_dir(_version, {_, task}) do
    if Mix.env == :test do
      "uploads/test/#{task.id}/temp"
    else
      "uploads/#{task.id}/temp"
    end
  end
end
