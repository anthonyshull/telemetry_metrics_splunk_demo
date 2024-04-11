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

If you want to test the demo against a real Splunk index, you can set the token and URL in `config/config.exs`.

## Adding a metric

Our goal is to send a metric to Splunk every time a user sends a `GET` request to `/`.

In order to do this, we need to execute a [telemetry](https://hexdocs.pm/telemetry/readme.html) event.

Uncomment the following line in `lib/telemetry_metrics_splunk_demo.ex`:

```
:telemetry.execute([:requests], %{get: 1})
```

Now, we need to tell the application that we care about sending these metrics to Splunk.
We do this using a [Telemetry Reporter](https://blog.miguelcoba.com/telemetry-and-metrics-in-elixir#heading-customreporter).

Uncomment the following lines in `lib/telemetry_metrics_splunk_demo/application.ex`:

```
alias Telemetry.Metrics

@token Application.compile_env!(:telemetry_metrics_splunk_demo, [:telemetry_metrics_splunk, :token])
@url Application.compile_env!(:telemetry_metrics_splunk_demo, [:telemetry_metrics_splunk, :url])

metrics = [
  Metrics.counter("requests.get")
]

{
  TelemetryMetricsSplunk, [
    metrics: metrics,
    token: @token,
    url: @url,
  ]
},
```

This adds the `TelemetryMetricsSplunk` reporter to the application's supervision tree with its required options.
`metrics` is a list of `Telemetry.Metrics` you can read more about [here](https://hexdocs.pm/telemetry_metrics/Telemetry.Metrics.html).
`token` is the Splunk HTTP Event Collector (HEC) token necessary to authorize requests to Splunk.
`url` is the Splunk endpoint.

You can read more about getting metrics into Splunk via the HEC [here](https://docs.splunk.com/Documentation/Splunk/9.2.1/Metrics/GetMetricsInOther#Get_metrics_in_from_clients_over_HTTP_or_HTTPS).

After making these changes to the code, restart the app and make another request:

```
%> curl http://localhost:9999
ok
```

If you configured an actual Splunk index, you should be able to search for it.
Otherwise, you'll see a log message coming from the demo server with the metric that would have been sent.

## Polling for metrics

Sending a metric every time a telemetry event is executed is great.
But, we can reduce the amount of data we send by polling for aggregations over time using [TelemetryPoller](https://hexdocs.pm/telemetry_poller/readme.html).

Revert your changes to the demo server:

```
%> git checkout lib/telemetry_metrics_splunk_demo.ex
```

Now, uncomment this line from `lib/telemetry_metrics_splunk_demo.ex`:

```
TelemetryMetricsSplunkDemo.GetCounter.increment()
```

We need some kind of state management to track the number of requests we get over time.
That's what the `TelemetryMetricsSplunkDemo.GetCounter` does.
And, the above line simply increments the counter every time a request is received.

Uncomment this line in `lib/telemetry_metrics_demo/application.ex`:

```
{TelemetryMetricsSplunkDemo.GetCounter, 0},
```

Next, we want to tell TelemetryPoller to check our counter by calling its `dispatch_stats` function every 10 seconds.
We also tell it to wait five seconds before it starts emitting events.

Uncomment these lines in `lib/telemetry_metrics_demo/application.ex`:

```
{
  :telemetry_poller, measurements: [
    {TelemetryMetricsSplunkDemo.GetCounter, :dispatch_stats, []}
  ],
  period: :timer.seconds(10),
  init_delay: :timer.seconds(5)
}
```

Restart the app and send it three requests:

```
%> for x in 1 2 3; do curl http://localhost:9999; done
ok
ok
ok
```

You'll see three GET requests came in to the server.
But, more importantly, you'll see that the metric sent is three.
In ten seconds, it will be set back to zero.

## More

Popular Elixir libraries are instrumented with telemetry out of the box.
Using the TelemetryMetricsSplunk reporter, you can easily set up Nebulex, Phoenix, or even the VM to dispatch stats and send them to Splunk.