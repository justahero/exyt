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
      body: build_body(client, code)
    ]

    HTTPotion.post(url, options) |> parse_response()
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

  defp build_body(%Client{} = client, code) do
    %{}
    |> Map.put(:code, code)
    |> Map.put(:client_id, URI.encode_www_form(client.client_id))
    |> Map.put(:client_secret, URI.encode_www_form(client.client_secret))
    |> Map.put(:redirect_uri, "http://justahero.de/auth/callback")
    |> Map.put(:grant_type, "authorization_code")
    |> URI.encode_query()
  end
  defp parse_response(%HTTPotion.Response{status_code: 200} = response) do
    json = Poison.decode!(response.body)
    {
      :ok,
      %Exyt.AccessToken{
        access_token: json["access_token"],
        refresh_token: json["refresh_token"],
        expires_in: json["expires_in"],
      }
    }
  end
  defp parse_response(%HTTPotion.Response{} = response) do
    {:error, "Status: #{response.status_code} - Body: #{response.body}"}
  end
  defp parse_response(%HTTPotion.ErrorResponse{} = response) do
    {:error, response.message}
  end
end
