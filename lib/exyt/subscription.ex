defmodule Exyt.Subscription do
  alias Exyt.{Client, Request, Response}

  @part "snippet,ContentDetails"

  @doc """
  
  Fetches a list of subscriptions.

  """
  @spec list(Client.t) :: {:ok, Response} | {:error, binary}
  def list(%Client{} = client) do
    query = URI.encode_query(mine: true, part: @part)
    Request.request(:get, client, "/subscriptions", query)
  end
end
