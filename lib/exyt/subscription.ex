defmodule Exyt.Subscription do
  alias Exyt.{Client, Request, Response}

  @part :id
  @filter %{mine: true}

  @filters   ["channelId", "id", "mine", "myRecentSubscribers", "mySubscribers"]
  @parts     ["contentDetails", "id", "snippet", "subscriberSnippet"]
  @optionals ["forChannelId", "maxResults", "order", "pageToken"]

  @type part     :: binary | atom
  @type filter   :: map()
  @type optional :: map()

  alias Exyt.Response

  @doc """

  Fetches a list of subscriptions.

  ## Parameters

    * `client` - (required) The Client struct to communicate with
    * `part` - A comma separated list of one or more subscription resource properties. see `@parts`
    * `filter` - A value to specify a filter, see `@filters`
    * `optional` - A list of optional filters and arguments to refine the result list, see `@optionals`

  """
  @spec list(Client.t, part, filter, map) :: {:ok, Response.t} | {:error, binary}
  def list(%Client{} = client, part \\ @part, filter \\ @filter, optional \\ %{}) do
    query = parse_arguments(part, filter, optional)
    Request.request(:get, client, "/subscriptions", query)
  end

  @doc false
  @spec parse_arguments(part, filter, optional) :: keyword()
  def parse_arguments(part, filter, optional) do
    %{}
    |> Map.put("part", parse_part(part))
    |> Map.merge(parse(filter, @filters))
    |> Map.merge(parse(optional, @optionals))
    |> Enum.sort()
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

  defp parse(opts, list) when is_list(opts) do
    Enum.into(opts, %{}) |> parse(list)
  end
  defp parse(opts, list) when is_map(opts) do
    opts
    |> Enum.reduce(%{}, fn({k,v}, acc) -> Map.put(acc, to_string(k), v) end)
    |> Enum.filter(fn{k, _} -> Enum.member?(list, k) end)
    |> Enum.into(%{})
  end
end
