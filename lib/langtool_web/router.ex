defmodule LangtoolWeb.Router do
  use LangtoolWeb, :router

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
    plug :put_user_session_id
    plug :put_user_token
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LangtoolWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index, as: :page
    # tasks resources
    resources "/tasks", TasksController, only: [:create]
    post "/tasks/detection", TasksController, :detection, as: :detection
    # users resources
    resources "/registrations", UserController, only: [:new, :create]
    get "/registrations/complete", UserController, :complete, as: :complete
    get "/registrations/confirm", UserController, :confirm, as: :confirm
    # sessions resources
    get "/signin", SessionController, :new
    delete "/signout", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", LangtoolWeb do
  #   pipe_through :api
  # end

  defp put_user_session_id(conn, _) do
    {conn, user_session_id} =
      conn
      |> get_session(:user_session_id)
      |> define_user_session_id(conn)
    assign(conn, :user_session_id, user_session_id)
  end

  defp define_user_session_id(nil, conn) do
    user_session_id = random_string(24)
    conn = put_session(conn, :user_session_id, user_session_id)
    {conn, user_session_id}
  end

  defp define_user_session_id(user_session_id, conn) do
    {conn, user_session_id}
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  defp put_user_token(conn, _) do
    if user_session_id = conn.assigns[:user_session_id] do
      token = Phoenix.Token.sign(conn, "user room socket", user_session_id)
      assign(conn, :user_room_token, token)
    else
      conn
    end
  end
end
