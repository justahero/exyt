# Exyt

[![Build Status](https://travis-ci.org/justahero/exyt.svg?branch=master)](https://travis-ci.org/justahero/exyt)

An elixir client for the [Youtube API (v3)](https://developers.google.com/youtube/v3/docs/).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exyt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:exyt, "~> 0.1.0"}]
end
```


## Authorization

Google's Youtube API uses [OAuth2](https://oauth.net/2/) to authenticate a user with its services. This requires first to have a set of credentials with which an authorization code can be obtained, where the user allows the application to be connected with the Google account. Once the user permits the application to connect with Google, the authorization code can then be used to fetch an access token. All endpoints of the Youtube API accept the access token to return results.

### Credentials

Google's authentication API requires to have a `client_id` and `client_secret`, both can be obtained on [Google's Credentials](https://console.developers.google.com/apis/credentials) page. On this page create **OAuth client ID** credentials. Once successfully created the credentials can be displayed. There are two ways to use these credentials with this library.

The recommended solution is to set application variables in the configuration file. **Please note** these credentials should stay outside of version control.

```elixir
# config/prod.exs
use Mix.Config
config :exyt,
  client_id: "123456…",
  client_secret: "abcdef…",
  redirect_uri: "http://example.com/callback"
```

With these settings in place the library picks up the configuration variables automatically. Instead of defining the credentials directly a more common approach is to use environment variables. For example to set environment variables via terminal:

```shell
export YOUTUBE_CLIENT_ID="123456…"
export YOUTUBE_CLIENT_SECRET="abcdef…"
```

Then the configuration file can be part of version control and just reads the environment variables:

```elixir
# config/config.exs
use Mix.Config
config :exyt,
  client_id: System.get_env["YOUTUBE_CLIENT_ID"],
  client_Secret: System.get_env["YOUTUBE_CLIENT_SECRET"],
  redirect_uri: "http://example.com/callback"
```

An alternative version is to set `client_id` and `client_secret` directly when creating the `Exyt.Client` struct:

```elixir
iex> client = Exyt.Client.new(client_id: "123456…", client_secret: "abcdef…", redirect_uri: "…")
%Exyt.Client{client_id: "123456…", client_secret: "abcdef…", redirect_uri: "…", …}
```

### Access Token

Once the credentials are configured, the first step in the OAuth2 process is to open Google's authorization page. For more information on the process of getting an access token see [Using OAuth2 for Web Server Applications](https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps) To provide all necessary settings as query arguments a utility function can be used to generate such a URL.

In case the required settings are configured as shown above, simply call:

```elixir
Exyt.Client.authorize_url()
"https://accounts.google.com/o/oauth2/auth?client_id=123456…&redirect_uri=http%3A%2F%2Fexample.com%2Fcallback&…"
```

The returned URL can be used for example to redirect a web application to Google's authorization page. The user then can select the Google account to connect the application with. Once confirmed Google will call back the page specified via `redirect_uri` setting as configured on the [Credentials](https://console.developers.google.com/apis/credentials) page. The authentication `code` is provided as query parameter and needs to be handled by the application.

An example callback may look like:

```
"http://example.com/callback?code=4%2FABCDEF…&state=state_parameter_passthrough_value&…"
```

The application needs to read the query parameter `code`. With the help of this authentication code an access token can be obtained. With the above `client` variable in place another function can be used to fetch an access token:

```elixir
code = "4\ABCDEF…"
case Exyt.Auth.access_token(client, code) do
  {:ok, token} ->
    IO.puts "Access token: #{inspect(token.access_token)}"
  {:error, message} ->
    IO.puts "Failed to fetch access token: #{message}"
end
```

Alternatively call `Exyt.Auth.access_token!\2` to fetch the token directly.


## Usage

The following list shows which API endpoints this library supports.

### Subscriptions


References

* https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps
* https://blog.timekit.io/google-oauth-invalid-grant-nightmare-and-how-to-fix-it-9f4efaf1da35


### Subscriptions

* https://developers.google.com/youtube/v3/guides/implementation/subscriptions
  * https://developers.google.com/youtube/v3/docs/subscriptions/list


## Development

The following libraries are used

* [HTTPotion](https://github.com/myfreeweb/httpotion) - a HTTP client library
* [Poison](https://github.com/devinus/poison) - a JSON library 


### Ressources

* [oauth2](https://github.com/scrogson/oauth2)
