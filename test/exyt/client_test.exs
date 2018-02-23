
defmodule Exyt.ClientTest do
  use ExUnit.Case, async: true

  doctest Exyt.Client

  alias Exyt.Client, as: Subject

  describe "new" do
    test "creates client if :token given" do
      client = Subject.new(token: "1234")

      assert client.token == "1234"
      assert client.site == "https://accounts.google.com"
    end
  end

  describe "authorize_url" do
    test "returns default URL" do
      client = Subject.new(token: "1234")

      assert Subject.authorize_url(client) == "https://accounts.google.com/o/oauth2/auth"
    end
  end
end
