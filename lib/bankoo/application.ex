defmodule Bankoo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BankooWeb.Telemetry,
      Bankoo.Repo,
      {DNSCluster, query: Application.get_env(:bankoo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Bankoo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Bankoo.Finch},
      # Start a worker by calling: Bankoo.Worker.start_link(arg)
      # {Bankoo.Worker, arg},
      # Start to serve requests, typically the last entry
      BankooWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bankoo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BankooWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
