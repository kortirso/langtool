use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :langtool, LangtoolWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :langtool, Langtool.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "kortirso",
  password: "",
  database: "langtool_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :arc, storage: Arc.Storage.Local
