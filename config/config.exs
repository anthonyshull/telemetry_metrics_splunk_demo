import Config

port = System.get_env("PORT") || 9999

config :telemetry_metrics_splunk_demo, port: port

config :telemetry_metrics_splunk_demo, :telemetry_metrics_splunk, token: "00000000-0000-0000-0000-000000000000"
config :telemetry_metrics_splunk_demo, :telemetry_metrics_splunk, url: "http://localhost:#{port}/services/collector"
