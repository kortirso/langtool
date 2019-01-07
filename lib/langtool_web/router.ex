defmodule LangtoolWeb.Router do
  use LangtoolWeb, :router
  alias Langtool.{Sessions}

  if Mix.env == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
    get "/preview_emails/:name/:type", LangtoolWeb.PreviewEmailController, :show
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_session_id
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :dashboard_layout do
    plug :put_layout, {LangtoolWeb.LayoutView, :dashboard}
  end

  scope "/", LangtoolWeb do
    pipe_through :browser # Use the default browser stack

    get "/", WelcomeController, :index, as: :welcome
    # tasks resources
    resources "/tasks", TasksController, only: [:create]
    post "/tasks/detection", TasksController, :detection, as: :detection
    # users resources
    resources "/registrations", RegistrationsController, only: [:create]
    get "/registrations", RegistrationsController, :new, as: :registration
    get "/registrations/complete", RegistrationsController, :complete, as: :complete
    get "/registrations/confirm", RegistrationsController, :confirm, as: :confirm
    # sessions resources
    get "/signin", SessionsController, :new
    post "/signin", SessionsController, :create
    delete "/signout", SessionsController, :delete
  end

  # dashboard resources
  scope "/dashboard", LangtoolWeb do
    pipe_through [:browser, :dashboard_layout]

    get "/", DashboardController, :index, as: :dashboard
    resources "/tasks", TasksController, only: [:index]
    resources "/users", UsersController, only: [:index, :show, :edit, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", LangtoolWeb do
  #   pipe_through :api
  # end

  defp put_session_id(conn, _) do
    {conn, session_id} =
      conn
      |> get_session(:session_id)
      |> define_session_id(conn)
    assign(conn, :session_id, session_id)
  end

  defp define_session_id(nil, conn) do
    {:ok, session} = Sessions.create_session()
    conn = put_session(conn, :session_id, session.id)
    {conn, session.id}
  end

  defp define_session_id(session_id, conn) do
    {conn, session_id}
  end

  defp put_user_token(conn, _) do
    if session_id = conn.assigns[:session_id] do
      token = Phoenix.Token.sign(conn, "user room socket", session_id)
      assign(conn, :user_room_token, token)
    else
      conn
    end
  end
end
