defmodule Exyt.Subscription do
  alias Exyt.{Client, Request, Response}

  @part "snippet,ContentDetails"

  alias Exyt.Response

  @doc """
  
  Fetches a list of subscriptions.

  ## Parameters

    * `client` - The Client struct to communicate with

  """
  @spec list(Client.t) :: {:ok, Response.t} | {:error, binary}
  def list(%Client{} = client) do
    query = URI.encode_query(mine: true, part: @part)
    Request.request(:get, client, "/subscriptions", query)
  end
end
