defmodule Bugsnag do
  @notify_url "https://notify.bugsnag.com"
  @request_headers [{"Content-Type", "application/json"}]

  alias Bugsnag.Payload
  use HTTPoison.Base

  def report(exception, options \\ []) do
    stacktrace = System.stacktrace
    spawn fn ->
      post(@notify_url,
           Payload.new(exception, stacktrace, options) |> to_json,
           @request_headers)
    end
  end

  def report_stacktrace(stacktrace, options \\ []) do
    exception = Exception.normalize(:error, nil, stacktrace)
    spawn fn ->
      post(@notify_url,
          Payload.new(exception, stacktrace, options) |> to_json,
          @request_headers)
    end
  end

  def to_json(payload) do
    payload
    |> Poison.encode!
  end
end
