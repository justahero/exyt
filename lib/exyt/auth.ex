defmodule Exyt.Auth do
  @moduledoc """
  
  A struct to fetch access / refresh token from the Youtube API

  """

  @default_headers [
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  ]

  alias Exyt.{AccessToken, Client}

  @doc """

  Fetches the access / refresh token

  ## Parameters

    * `client` - The Client struct to fetch access token with
    * `code` - The authorization code fetched from OAuth2 callback

  Returns a tuple with access token or an error message
  """
  @spec access_token(Client.t, binary) :: {:ok, AccessToken.t} | {:error, binary}
  def access_token(%Client{} = client, code) do
    url = Client.token_url(client)

    options = [
      headers: @default_headers,
      body: build_access_body(client, code)
    ]

    HTTPotion.post(url, options) |> parse_response(client)
  end

  @doc """

  Fetches the access / refresh token

  ## Parameters

    * `client` - The client struct to fetch access token with
    * `code` - The authorization code fetched from OAuth2 callback

  Returns a `%Exyt.AccessToken` with the token or raises an exception with error message
  """
  @spec access_token!(Client.t, binary) :: AccessToken.t
  def access_token!(%Client{} = client, code) do
    case access_token(client, code) do
      {:ok, token}      -> token
      {:error, message} -> raise message
    end
  end

  @doc """

  Fetches a new access token by using the refresh token.

  Getting a new access token only works when the request of `Auth.access_token` inlcudes the
  `grant_type=offline` query parameter. This is in order to allow refreshing an expired access token.
  For more details see [Refreshing an Access Token](https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps#offline).

  ## Parameters

    * `client` - The client struct that contains the access token.

  """
  @spec refresh_token(Client.t) :: {:ok, AccessToken.t} | {:error, binary}
  def refresh_token(%Client{} = client) do
    url = Client.token_url(client)

    options = [
      headers: @default_headers,
      body: build_refresh_body(client)
    ]

    HTTPotion.post(url, options) |> parse_response(client)
  end

  defp build_access_body(%Client{} = client, code) do
    client
    |> Map.take([:client_id, :client_secret, :redirect_uri])
    |> Map.put(:code, code)
    |> Map.put(:grant_type, "authorization_code")
    |> URI.encode_query()
  end
  defp build_refresh_body(%Client{token: %AccessToken{refresh_token: token}} = client) do
    client
    |> Map.take([:client_id, :client_secret])
    |> Map.put(:refresh_token, token)
    |> Map.put(:grant_type, "refresh_token")
    |> URI.encode_query()
  end

  defp parse_response(%HTTPotion.Response{status_code: 200} = response, %Client{} = client) do
    json  = Poison.decode!(response.body)
    token = client.token || %AccessToken{}
    {
      :ok,
      Map.merge(token, parse_token(json))
    }
  end
  defp parse_response(%HTTPotion.Response{} = response, %Client{}) do
    {:error, "Status: #{response.status_code} - Body: #{response.body}"}
  end
  defp parse_response(%HTTPotion.ErrorResponse{} = response, %Client{}) do
    {:error, response.message}
  end
  defp parse_token(%{"access_token" => access, "refresh_token" => refresh} = json) do
    %{
      access_token: access,
      refresh_token: refresh,
      expires_in: json["expires_in"],
    }
  end
  defp parse_token(%{"access_token" => access} = json) do
    %{
      access_token: access,
      expires_in: json["expires_in"],
    }
  end
end
