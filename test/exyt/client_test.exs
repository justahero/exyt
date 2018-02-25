defmodule Exyt.ClientTest do
  use ExUnit.Case, async: true

  doctest Exyt.Client

  alias Exyt.Client, as: Subject

  @authorize_query "access_type=offline" <>
                   "&client_id=" <>
                   "&redirect_uri=" <>
                   "&response_type=code" <>
                   "&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fyoutube"

  @token_query "client_id=" <>
               "&client_secret=" <>
               "&code=1234" <>
               "&grant_type=authorization_code" <>
               "&redirect_uri="

  describe "new" do
    test "creates client if :token given" do
      client = Subject.new(token: "1234")

      assert client.token == "1234"
      assert client.site == "https://accounts.google.com"
    end
  end

  describe "authorize_url" do
    test "returns default URL" do
      assert Subject.authorize_url() ==
        "https://accounts.google.com/o/oauth2/auth?" <> @authorize_query
    end

    test "returns URL with custom site" do
      client = Subject.new(site: "https://example.com")

      assert Subject.authorize_url(client) ==
        "https://example.com/o/oauth2/auth?" <> @authorize_query
    end

    test "joins URL correctly when not starting with /" do
      client = Subject.new(authorize_url: "test")

      assert Subject.authorize_url(client) ==
        "https://accounts.google.com/test?" <> @authorize_query
    end
  end

  describe "token_url" do
    test "returns default URL" do
      client = Subject.new()

      assert Subject.token_url(client, "1234") ==
        "https://accounts.google.com/o/oauth2/token?" <> @token_query
    end
  end
end
