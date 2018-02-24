# Exyt

An elixir client for the [Youtube API (v3)](https://developers.google.com/youtube/v3/docs/).

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exyt` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exyt, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exyt](https://hexdocs.pm/exyt).


## Usage

The following functionality can be used with this library

### Authentication

Google's Youtube API uses [OAuth2](https://oauth.net/2/) to authenticate a user with the service. This library provides a `Client` struct
that can help in the authentication process:

```elixir
iex> Exyt.Client.new() |> Exyt.Client.authorize_url()
""
```


References

* https://blog.timekit.io/google-oauth-invalid-grant-nightmare-and-how-to-fix-it-9f4efaf1da35


### Subscriptions

* https://developers.google.com/youtube/v3/guides/implementation/subscriptions


## Development

The following libraries are used

* [HTTPotion](https://github.com/myfreeweb/httpotion) - a HTTP client library
* [Poison](https://github.com/devinus/poison) - a JSON library 
* [Mock](https://github.com/jjh42/mock) - a library for mocking HTTP requests in tests
