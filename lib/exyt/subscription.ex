defmodule Exyt.Subscription do
  alias Exyt.{Client, Request, Response}

  @part "snippet,ContentDetails"

  alias Exyt.Response

  @doc """
  
  Fetches a list of subscriptions.

  ## Parameters

    * `client` - The Client struct to communicate with
    * `part` - A combination of the following, "snippet", "contentDetails", "id", "subscriberSnippet"

  """
  @spec list(Client.t, binary) :: {:ok, Response.t} | {:error, binary}
  def list(%Client{} = client, part \\ @part) do
    query = %{mine: true, part: part}

    Request.request(:get, client, "/subscriptions", query)
  end
end
