use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :es_bank, EsBank.Repo,
  username: "postgres",
  password: "postgres",
  database: "es_bank_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox


config :es_bank, EsBank.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.InMemory,
    serializer: Commanded.Serialization.JsonSerializer
  ]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :es_bank, EsBankWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
