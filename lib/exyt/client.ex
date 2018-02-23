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

  @type authorize_url :: binary
  @type client_id     :: binary
  @type redirect_uri  :: binary
  @type site          :: binary
  @type token         :: binary
  @type token_url     :: binary

  @type t :: %__MODULE__ {
    authorize_url: authorize_url,
    client_id:     client_id,
    redirect_uri:  redirect_uri,
    site:          site,
    token:         token,
    token_url:     token_url
  }

  defstruct authorize_url: @authorize_url,
            client_id: "",
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

  @doc """

  Returns the authorization url with request token and redirect uri

  ## Example

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

  def token_url(%Client{} = client) do
    endpoint(client, client.token_url)
  end

  defp endpoint(client, <<"/"::utf8, _::binary>> = endpoint) do
    client.site <> endpoint
  end
  defp endpoint(client, endpoint) do
    client.site <> "/" <> endpoint
  end
end
