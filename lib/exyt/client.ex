defmodule Exyt.Client do
  @site_url "https://accounts.google.com"

  @authorize_url "/o/oauth2/auth"
  @token_url "/o/oauth2/token"

  @api_url "https://www.googleapis.com/youtube/v3"
  @scope "https://www.googleapis.com/auth/youtube"

  @client_id Application.get_env(:exyt, :client_id, "")
  @client_secret Application.get_env(:exyt, :client_secret, "")
  @redirect_uri Application.get_env(:exyt, :redirect_uri, "")

  alias Exyt.{AccessToken, Client}

  @moduledoc """
  This module defines a basic client to communicate with the Youtube API.
  """

  @type api_url       :: binary
  @type authorize_url :: binary
  @type client_id     :: binary
  @type client_secret :: binary
  @type redirect_uri  :: binary
  @type site          :: binary
  @type token         :: AccessToken.t | nil
  @type token_url     :: binary

  @type t :: %__MODULE__ {
    api_url:       api_url,
    authorize_url: authorize_url,
    client_id:     client_id,
    redirect_uri:  redirect_uri,
    site:          site,
    token:         token,
    token_url:     token_url
  }

  defstruct api_url: @api_url,
            authorize_url: @authorize_url,
            client_id: @client_id,
            client_secret: @client_secret,
            redirect_uri: @redirect_uri,
            site: @site_url,
            token: nil,
            token_url: @token_url

  @doc """

  Builds a Client struct

  ## Client struct fields

    * `authorize_url` - absolute or relative URL path to authorization endpoint
    * `site` - The site URL to authenticate with
    * `token` - The `%Exyt.AccessToken{}` struct received after successful authorization

  ## Examples

      iex> Exyt.Client.new(token: "123456")
      %Exyt.Client{api_url: "https://www.googleapis.com/youtube/v3",
      authorize_url: "/o/oauth2/auth", client_id: "", client_secret: "",
      redirect_uri: "", site: "https://accounts.google.com",
      token: %Exyt.AccessToken{access_token: "123456", expires_in: nil,
      refresh_token: ""}, token_url: "/o/oauth2/token"}

  """
  @spec new(t, Keyword.t) :: t
  def new(client \\ %Client{}, opts) do
    {token, opts} = Keyword.pop(opts, :token)

    opts =
      opts
      |> Keyword.put(:token, process_token(token))

    struct(client, opts)
  end
  def new(), do: new(%Client{}, [])

  defp process_token(nil), do: nil
  defp process_token(token) when is_binary(token), do: AccessToken.new(token)
  defp process_token(%AccessToken{} = token), do: token

  @doc """

  Returns the authorization url with request token and redirect uri

  ## Example

      iex> Exyt.Client.authorize_url()
      "https://accounts.google.com/o/oauth2/auth?access_type=offline&client_id=&" <>
      "include_granted_scopes=true&redirect_uri=&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube" <>
      "&state=state_parameter_passthrough_value"

  """
  @spec authorize_url(t, binary) :: binary
  def authorize_url(%Client{} = client, scope \\ @scope) do
    params =
      %{}
      |> Map.put(:access_type, "offline")
      |> Map.put(:client_id, client.client_id)
      |> Map.put(:include_granted_scopes, true)
      |> Map.put(:state, "state_parameter_passthrough_value")
      |> Map.put(:redirect_uri, client.redirect_uri)
      |> Map.put(:response_type, "code")
      |> Map.put(:scope, scope)

    endpoint(client, client.authorize_url) <> "?" <> URI.encode_query(params)
  end
  def authorize_url(), do: authorize_url(%Client{})

  @doc """
  
  Returns the token url to request an access token. This token is used to
  access the different API functions.

  ## Example

      iex> Exyt.Client.token_url()
      "https://accounts.google.com/o/oauth2/token"

  """
  @spec token_url(t) :: binary
  def token_url(%Client{} = client) do
    endpoint(client, client.token_url)
  end
  def token_url(), do: token_url(%Client{})

  defp endpoint(client, <<"/"::utf8, _::binary>> = endpoint) do
    client.site <> endpoint
  end
  defp endpoint(client, endpoint) do
    client.site <> "/" <> endpoint
  end
end
