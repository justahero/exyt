defmodule Exyt.Request do
  @moduledoc false

  @default_headers %{
    "Content-Type": "application/json",
    "Accept": "application/json"
  }

  alias Exyt.{Client, Response}
  require HTTPotion

  @typedoc "Response type returned from `request/4`"
  @type t :: {:ok, Response.t} | {:error, binary}

  @doc """
  Makes a HTTP request to the Youtube API.

  ## Parameters

    * `method` - atom, the HTTP method to run, e.g. `:get`, `:post` 
    * `client` - the `Client` struct to run with
    * `path` - the API path to execute, e.g. "/subscriptions"
    * `query` - optional map of query parameters

  """
  @spec request(atom, Client.t, binary, map) :: t
  def request(method, %Client{} = client, path, query \\ []) do
    url = build_url(client.api_url, path, query)

    options = [
      headers: process_headers(client)
    ]

    HTTPotion.request(:get, url, options)
    |> parse_response()
  end

  defp process_headers(%Client{token: token}) do
    %{}
    |> Map.put("Authorization", "BEARER #{token}")
    |> Map.merge(@default_headers)
    |> Map.to_list()
  end

  @spec build_url(binary, binary, binary) :: binary
  defp build_url(base_url, path, query) do
    base_url <> path <> "?" <> query
  end

  defp parse_response(%HTTPotion.Response{} = response) do
    {:ok,
      %Exyt.Response{
        status_code: response.status_code,
        body: response.body,
        headers: response.headers.hdrs
      }
    }
  end
  defp parse_response(%HTTPotion.ErrorResponse{} = response) do
    {:error, response.message}
  end
end