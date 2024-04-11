defmodule TelemetryMetricsSplunkDemo do
  require Logger

  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    Logger.debug("#{__MODULE__} GET /")

    # :telemetry.execute([:requests], %{get: 1})

    # TelemetryMetricsSplunkDemo.GetCounter.increment()

    send_resp(conn, 200, "ok\n")
  end

  post "/services/collector" do
    {:ok, body, conn} = Plug.Conn.read_body(conn, read_timeout: 500)

    data = Jason.decode!(body)

    Logger.debug("#{__MODULE__} POST /services/collector #{inspect(data)}")

    send_resp(conn, 200, "ok\n")
  end

  match _ do
    send_resp(conn, 404, "not ok\n")
  end
end
