defmodule LangtoolWeb.FileCase do
  def remove_test_files do
    File.rm_rf("uploads/test")
  end
end