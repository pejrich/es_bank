# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :es_bank,
  ecto_repos: [EsBank.Repo],
  event_stores: [EsBank.EventStore]

config :es_bank, EsBank.App,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: EsBank.EventStore
  ],
  pubsub: :local,
  registry: :local

# Configures the endpoint
config :es_bank, EsBankWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7rus4ge1nwUSjdbBMa8EaFE3r6Ejc8iXQeSWEfNdChA8c5lE7OxP8CnpF5ju294k",
  render_errors: [view: EsBankWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EsBank.PubSub,
  live_view: [signing_salt: "qxm5ige2"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
