ExUnit.start()
Application.ensure_all_started(:bypass)

defmodule PathHelpers do
  @moduledoc false

  def fixture_path() do
    Path.expand("./fixtures", __DIR__)
  end

  def fixture_path(file_path) do
    Path.join(fixture_path(), file_path)
  end

  def load_json(file_path) do
    file_path |> fixture_path() |> File.read()
  end

  def load_json!(file_path) do
    case load_json(file_path) do
      {:ok, file}      -> file
      {:error, reason} -> raise reason
    end
  end
end

defmodule Exyt.TestHelpers do
  @moduledoc false

  import Plug.Conn
  import PathHelpers

  def bypass_server(%Bypass{port: port}) do
    "http://localhost:#{port}"
  end

  def json_response(conn, status_code, file_path) do
    conn
    |> put_resp_header("content-type", "application/json")
    |> send_resp(status_code, load_json!(file_path) |> Poison.encode!())
  end
end
