defmodule MiniBlog.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MiniBlogWeb.Telemetry,
      MiniBlog.Repo,
      {DNSCluster, query: Application.get_env(:mini_blog, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MiniBlog.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MiniBlog.Finch},
      # Start a worker by calling: MiniBlog.Worker.start_link(arg)
      # {MiniBlog.Worker, arg},
      # Start to serve requests, typically the last entry
      MiniBlogWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MiniBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MiniBlogWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
