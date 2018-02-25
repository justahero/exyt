defmodule Exyt.Client do
  @site_url "https://accounts.google.com"

  @authorize_url "/o/oauth2/auth"
  @token_url "/o/oauth2/token"

  @api_url "https://www.googleapis.com/youtube/v3"
  @scope "https://www.googleapis.com/auth/youtube"

  alias Exyt.{Client}

  @moduledoc """
  This module defines a basic client to communicate with the Youtube API.
  """

  @type api_url       :: binary
  @type authorize_url :: binary
  @type client_id     :: binary
  @type client_secret :: binary
  @type redirect_uri  :: binary
  @type site          :: binary
  @type token         :: binary
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
            client_id: "",
            client_secret: "",
            redirect_uri: "",
            site: @site_url,
            token: nil,
            token_url: @token_url

  @doc """

  Builds a Client struct

  ## Client struct fields

    * `authorize_url` - absolute or relative URL path to authorization endpoint
    * `site` - The site URL to authenticate with
    * `token` - The access token received after successful authorization

  ## Examples

      iex> Exyt.Client.new(token: "123456")
      %Exyt.Client{token: "123456"}

  """
  @spec new(t, Keyword.t) :: t
  def new(client \\ %Client{}, opts) do
    struct(client, opts)
  end
  def new(), do: new(%Client{}, %{})

  @doc """

  Returns the authorization url with request token and redirect uri

  ## Example

      iex> Exyt.Client.authorize_url()
      "https://accounts.google.com/o/oauth2/auth?client_id=&redirect_uri=&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube"

      iex> Exyt.Client.authorize_url(%Exyt.Client{})
      "https://accounts.google.com/o/oauth2/auth?client_id=&redirect_uri=&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube"

  """
  @spec authorize_url(t, binary) :: binary
  def authorize_url(%Client{} = client, scope \\ @scope) do
    params =
      %{}
      |> Map.put(:response_type, "code")
      |> Map.put(:client_id, client.client_id)
      |> Map.put(:redirect_uri, client.redirect_uri)
      |> Map.put(:scope, scope)

    endpoint(client, client.authorize_url) <> "?" <> URI.encode_query(params)
  end
  def authorize_url(), do: authorize_url(%Client{})

  @doc """
  
  Returns the token url to request an access token. This token is used to
  access the different API functions.

  ## Example

      iex> Exyt.Client.token_url(Exyt.Client.new(), "1234")
      "https://accounts.google.com/o/oauth2/token?client_id=&client_secret=&code=1234&grant_type=authorization_code&redirect_uri="

  """
  @spec token_url(t, binary | String.Chars.t) :: binary
  def token_url(%Client{} = client, code) do
    params =
      %{}
      |> Map.put(:code, code)
      |> Map.put(:client_id, client.client_id)
      |> Map.put(:client_secret, client.client_secret)
      |> Map.put(:redirect_uri, client.redirect_uri)
      |> Map.put(:grant_type, "authorization_code")

    endpoint(client, client.token_url) <> "?" <> URI.encode_query(params)
  end

  defp endpoint(client, <<"/"::utf8, _::binary>> = endpoint) do
    client.site <> endpoint
  end
  defp endpoint(client, endpoint) do
    client.site <> "/" <> endpoint
  end
end
