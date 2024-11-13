defmodule TelemetryMetricsSplunkDemo.Application do
  require Logger

  use Application

  alias Telemetry.Metrics

  @port Application.compile_env!(:telemetry_metrics_splunk_demo, :port)
  @token Application.compile_env!(:telemetry_metrics_splunk_demo, [:telemetry_metrics_splunk, :token])
  @url Application.compile_env!(:telemetry_metrics_splunk_demo, [:telemetry_metrics_splunk, :url])

  @impl true
  def start(_type, _args) do
    metrics = [
      Metrics.counter("requests.get")
    ]

    children = [
      {Plug.Cowboy, scheme: :http, plug: TelemetryMetricsSplunkDemo, options: [port: @port]},
      {Finch, name: MyFinch},
      {
        TelemetryMetricsSplunk, [
          finch: MyFinch,
          metrics: metrics,
          token: @token,
          url: @url,
        ]
      },
      {TelemetryMetricsSplunkDemo.GetCounter, 0},
      {
        :telemetry_poller, measurements: [
          {TelemetryMetricsSplunkDemo.GetCounter, :dispatch_stats, []}
        ],
        period: :timer.seconds(10),
        init_delay: :timer.seconds(5)
      }
    ]

    Logger.info("Starting the demo server on port #{@port}")

    opts = [strategy: :one_for_one, name: TelemetryMetricsSplunkDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
