# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :langtool,
  ecto_repos: [Langtool.Repo]

# Configures the endpoint
config :langtool, LangtoolWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3TW0IOt9y/4Av2ceU/OO6lwdMB7kjXEQEFwW3YXxeETilb11Yb6MvV3sIMHLrbKM",
  render_errors: [view: LangtoolWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Langtool.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
