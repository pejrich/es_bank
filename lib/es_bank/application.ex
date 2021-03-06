defmodule EsBank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      EsBank.Repo,
      # Start the Telemetry supervisor
      EsBankWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EsBank.PubSub},
      # Start the Endpoint (http/https)
      EsBankWeb.Endpoint,
      # EsBank,
      EsBank.App,
      # Start a worker by calling: EsBank.Worker.start_link(arg)
      EsBank.Accounts.Projectors.Account,
      EsBank.EventHandlers.AccountEventHandler,
      EsBank.ProcessMangers.AtmProcessManager,
      # {EsBank.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EsBank.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EsBankWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
