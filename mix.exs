defmodule TelemetryMetricsSplunkDemo.MixProject do
  use Mix.Project

  def project do
    [
      app: :telemetry_metrics_splunk_demo,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {TelemetryMetricsSplunkDemo.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "1.4.1"},
      {:plug_cowboy, "2.7.1"},
      {:telemetry_metrics_splunk, "0.0.6-alpha"},
      {:telemetry_poller, "1.1.0"}
    ]
  end
end
