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
    url = process_url(client.site, path)

    options = [
      headers: process_headers(client)
    ]

    HTTPotion.request(:get, url, [])
  end

  defp process_headers(%Client{token: token}) do
    %{}
    |> Map.put("Authorization", "BEARER #{token}")
    |> Map.merge(@default_headers)
    |> Map.to_list()
  end

  @spec process_url(binary, binary | String.Chars.t) :: binary
  defp process_url(base_url, path) do
    base_url
    |> to_string()
    |> URI.merge(path |> to_string())
    |> to_string()
  end
end
