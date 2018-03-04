defmodule Exyt.Subscription do
  alias Exyt.{Client, Request, Response}

  @part :id
  @filter :mine

  @filters   [:channelId, :id, :mine, :myRecentSubscribers, :mySubscribers]
  @parts     ["contentDetails", "id", "snippet", "subscriberSnippet"]

  @optionals [
    :forChannelId,
    :maxResults,
    :onBehalfOfContentOwner,
    :onBehalfOfContentOwnerChannel,
    :order,
    :pageToken
  ]

  @type part     :: binary | atom
  @type filter   :: binary | atom
  @type optional :: map()

  alias Exyt.Response

  @doc """

  Fetches a list of subscriptions.

  ## Parameters

    * `client` - (required) The Client struct to communicate with
    * `part` - (required) A comma separated list of one or more subscription resource properties. see `@parts`
    * `filter` - A value to specify a filter, see `@filters`
    * `optional` - A list of optional filters and arguments to refine the result list

  """
  @spec list(Client.t, part, filter, map) :: {:ok, Response.t} | {:error, binary}
  def list(%Client{} = client, part \\ @part, filter \\ @filter, optional \\ %{}) do
    query = parse_arguments(part, filter, optional)
    Request.request(:get, client, "/subscriptions", query)
  end

  @spec parse_arguments(part, filter, optional) :: map()
  def parse_arguments(part, filter, optional) do
    %{mine: true, part: parse_part(part)}
  end

  def parse_part(part) when is_atom(part), do: parse_part([part])
  def parse_part(part) when is_binary(part), do: parse_part([part])
  def parse_part(parts) when is_list(parts) do
    parts
    |> Enum.map(fn(part) -> to_string(part) end)
    |> Enum.filter(fn(part) -> Enum.member?(@parts, part) end)
    |> Enum.sort()
    |> Enum.join(",")
  end
end
