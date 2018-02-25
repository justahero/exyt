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

  """
  @spec access_token(Client.t, binary) :: {:ok, AccessToken.t} | {:error, binary}
  def access_token(%Client{} = client, code) do
    url = Client.token_url(client, code)

    options = [
      headers: @default_headers,
      body: build_body(client, code)
    ]

    HTTPotion.request(:post, url, options) |> parse_response()
  end

  defp build_body(%Client{} = client, code) do
    %{}
    |> Map.put(:code, code)
    |> Map.put(:client_id, client.client_id)
    |> Map.put(:client_secret, client.client_secret)
    |> Map.put(:redirect_uri, client.redirect_uri)
    |> Map.put(:grant_type, "authorization_code")
  end
  defp parse_response(%HTTPotion.Response{} = response) do
    {
      :ok,
      %Exyt.AccessToken{
        access_token: response.body["access_token"],
        refresh_token: response.body["refresh_token"],
        expires_in: response.body["expires_in"],
      }
    }
  end
  defp parse_response(%HTTPotion.ErrorResponse{} = response) do
    {:error, response.message}
  end
end
