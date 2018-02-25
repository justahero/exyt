defmodule Exyt.SubscriptionTest do
  use ExUnit.Case, async: true

  doctest Exyt.Subscription

  import Exyt.TestHelpers

  alias Exyt.Client
  alias Exyt.Subscription, as: Subject

  setup do
    bypass = Bypass.open()
    client = Client.new(token: "1234", api_url: bypass_server(bypass))
    {:ok, client: client, bypass: bypass}
  end

  describe "list" do
    test "returns successful response", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "mine=true&part=snippet%2CContentDetails"

        json_response(conn, 200, "subscriptions.json")
      end

      {:ok, response} = Subject.list(client)

      assert 200 == response.status_code
      assert Poison.Parser.parse!(response.body)
    end
  end
end
