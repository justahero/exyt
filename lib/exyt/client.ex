defmodule Exyt.Client do
  @auth_site_url "https://accounts.google.com"

  @auth_authorize_url "/o/oauth2/auth"
  @auth_token_url "/o/oauth2/token"

  @youtube_api_url "https://www.googleapis.com/youtube/v3"

  @moduledoc """
  A basic client to communicate with Youtube API
  """

  @type t :: %__MODULE__ {
    access_token: String.t,
    site: String.t
  }

  defstruct access_token: nil,
            site: nil

  @doc """

  Builds a Client with access token

  ## Parameters

    - access_token: The access token received after successful authorization
                    with the OAuth2 endpoint
    - site: An alternative site url to override for tests

  ## Examples

      iex> Youtube.Client.new(%{access_token: "123456"})
      %Youtube.Client{access_token: "123456", site: "https://accounts.google.com"}

  """
  @spec new(%{access_token: String.t}) :: t
  def new(%{access_token: access_token} = options) do
    %__MODULE__ {
      access_token: access_token,
      site: Map.get(options, :site, @auth_site_url)
    }
  end

  @doc """

  
  
  """
  @spec authorize_url(map) :: String.t
  def authorize_url(%{"request_token" => token, "redirect_uri" => redirect_uri}) do
    query = %URI{query: "request_token=#{token}"}

    @auth_site_url
    |> URI.merge(@auth_authorize_url)
    |> URI.merge(query)
    |> URI.to_string()
  end

  @spec authorize_url() :: String.t
  def authorize_url() do
    @auth_site_url
    |> URI.merge(@auth_authorize_url)
    |> URI.to_string()
  end

  @spec token_url() :: String.t
  def token_url() do
    @auth_site_url
    |> URI.merge(@auth_token_url)
    |> URI.to_string()
  end

  defp api_url() do
    Application.get_env(:exyt, :api_url, @youtube_api_url)
  end
end
