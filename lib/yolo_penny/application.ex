defmodule YoloPenny.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      YoloPennyWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:yolo_penny, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: YoloPenny.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: YoloPenny.Finch},
      # Start a worker by calling: YoloPenny.Worker.start_link(arg)
      # {YoloPenny.Worker, arg},
      # Start to serve requests, typically the last entry
      YoloPennyWeb.Endpoint,
      {YoloPenny.Users.UserServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YoloPenny.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    YoloPennyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
