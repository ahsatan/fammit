defmodule Fammit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FammitWeb.Telemetry,
      Fammit.Repo,
      {DNSCluster, query: Application.get_env(:fammit, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Fammit.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Fammit.Finch},
      # Start a worker by calling: Fammit.Worker.start_link(arg)
      # {Fammit.Worker, arg},
      # Start to serve requests, typically the last entry
      FammitWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Fammit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FammitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
