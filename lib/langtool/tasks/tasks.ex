defmodule Langtool.Tasks do
  @moduledoc """
  The Tasks context
  """

  import Ecto.Query, warn: false
  alias Langtool.{Repo, Tasks.Task}

  @doc """
  Get tasks list for user

  ## Examples

      iex> get_tasks_for_user(user)

  """
  def get_tasks_for_user(current_user) do
    current_user
    |> Ecto.assoc(:tasks)
    |> order_by(desc: :id)
    |> Repo.all()
  end

  @doc """
  Gets a single task

  ## Examples

      iex> get_task(123)
      %Task{}

      iex> get_task(123)
      nil

  """
  def get_task(id) when is_integer(id), do: Repo.get(Task, id)

  @doc """
  Creates a task

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(params) when is_map(params) do
    %Task{}
    |> Task.create_changeset(params)
    |> Repo.insert()
  end

  @doc """
  Update status of the task

  ## Examples

      iex> update_task_status(task, status)
      {:ok, %Task{}}

  """
  def update_task_status(%Task{} = task, status) when is_binary(status) do
    task
    |> Task.localizator_changeset(%{status: status})
    |> Repo.update()
  end

  @doc """
  Attaches file to task

  ## Examples

      iex> attach_file(task, %{field: value})

  """
  def attach_file(%Task{} = task, params) when is_map(params) do
    task
    |> Task.file_changeset(params)
    |> Repo.update()
  end

  @doc """
  Updates attached file

  ## Examples

      iex> update_file(task, path_to_file, %{})

  """
  def update_file(%Task{} = task, path_to_file, converted_data) when is_binary(path_to_file) and is_map(converted_data) do
    {:ok, result} = Yml.write_to_string(%{task.from => converted_data})
    File.write(path_to_file, result)
  end

  @doc """
  Attaches result file to task

  ## Examples

      iex> save_result_file("content", task)

  """
  def save_result_file(result_file_content, %Task{} = task) when is_binary(result_file_content) do
    result_file_name = task.to <> ".yml"
    # create temp folder
    temp_folder = File.cwd! |> Path.join(Langtool.File.temp_storage_dir(:original, {:abc, task}))
    File.mkdir(temp_folder)
    # create temp file
    temp_file_path = temp_folder <> "/#{result_file_name}"
    File.write(temp_file_path, result_file_content)
    # attach temp file as result to task
    save_result = attach_result_file(task, %{result_file: %Plug.Upload{filename: result_file_name, path: temp_file_path}})
    # delete temp file
    File.rm(temp_file_path)
    save_result
  end

  defp attach_result_file(%Task{} = task, params) do
    task
    |> Task.result_file_changeset(params)
    |> Repo.update()
  end

  @doc """
  Detects locale for file

  ## Examples

      iex> detect_locale(filename, path)
      {:ok, %{code: "en"}}

      iex> detect_locale(filename, path)
      {:error, ""}

  """
  def detect_locale(filename, path) when is_binary(filename) and is_binary(path) do
    extension =
      filename
      |> String.split(".")
      |> Enum.at(-1)
    I18nParser.detect(path, extension)
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

  """
  def delete_task(%Task{} = task), do: Repo.delete(task)
end
