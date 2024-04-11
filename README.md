# TelemetryMetricsSplunkDemo

Clone this repo and start the server:

```
%> git clone git@github.com:anthonyshull/telemetry_metrics_splunk_demo.git
%> cd telemetry_metrics_splunk_demo
%> mix deps.get
%> mix run --no-halt
```

You can set a port with the environment variable `PORT=`.
Otherwise, the default port of `9999` is used.

In another terminal you can confirm the server is listening:

```
%> curl http://localhost:9999
ok
```

By default, the application will send metrics to itself.

If you want to test the demo against a real Splunk index, you can set the URL and Token in `config/config.exs`.

## Adding a metric

Our goal is to send a metric to Splunk every time a user sends a `GET` request to `/`.

## Polling for metrics


