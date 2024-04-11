defmodule TelemetryMetricsSplunkDemo.GetCounter do
  use Agent

  def start_link(initial_value \\ 0) do
    Agent.start_link(fn -> initial_value end, name: __MODULE__)
  end

  def increment do
    Agent.update(__MODULE__, &(&1 + 1))
  end

  def dispatch_stats() do
    :telemetry.execute([:requests], %{get: Agent.get(__MODULE__, & &1)})

    Agent.update(__MODULE__, fn _ -> 0 end)
  end
end
