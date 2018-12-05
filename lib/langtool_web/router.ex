defmodule LangtoolWeb.Router do
  use LangtoolWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LangtoolWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/tasks", TasksController, only: [:create]
    post "/tasks/detection", TasksController, :detection, as: :detection
  end

  # Other scopes may use custom stacks.
  # scope "/api", LangtoolWeb do
  #   pipe_through :api
  # end
end
