defmodule Exyt.AccessToken do
  @moduledoc """
  
  A struct to represent an OAuth2 access token.

  """

  alias Exyt.AccessToken

  @type access_token  :: binary
  @type refresh_token :: binary
  @type expires_in    :: integer

  @type t :: %__MODULE__ {
    access_token:  access_token,
    refresh_token: refresh_token,
    expires_in:    expires_in
  }

  defstruct access_token: "",
            refresh_token: "",
            expires_in: nil

  @doc """
  
  Builds a struct with OAuth access tokens

  ## Client struct fields

    * `access_token` - The access token to use with the Youtube API
    * `refresh_token` - The refresh token to update the access token on subsequent requests
    * `expires_in` - The lifetime of the access token in seconds

  ## Examples:

      iex> Exyt.AccessToken.new("1234")
      %Exyt.AccessToken{access_token: "1234"}

      iex> Exyt.AccessToken.new(%Exyt.AccessToken{}, %{access_token: "1234"})
      %Exyt.AccessToken{access_token: "1234"}

      iex> Exyt.AccessToken.new(%{access_token: "1234", refresh_token: "abcd"})
      %Exyt.AccessToken{access_token: "1234", refresh_token: "abcd"}

  """
  @spec new(binary) :: t
  def new(token) when is_binary(token) do
    new(access_token: token)
  end

  @spec new(t, map) :: t
  def new(token \\ %AccessToken{}, opts) do
    struct(token, opts)
  end
end
