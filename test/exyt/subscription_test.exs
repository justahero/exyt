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
        assert List.keyfind(conn.req_headers, "authorization", 0) == {"authorization", "Bearer 1234"}
        assert conn.request_path == "/subscriptions"
        assert conn.query_string == "mine=true&part=id"

        json_response(conn, 200, "subscriptions.json")
      end

      {:ok, response} = Subject.list(client)

      assert 200 == response.status_code
      assert Enum.count(response.headers) > 0
    end

    test "accepts part with list of atoms", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "mine=true&part=contentDetails%2Cid"

        json_response(conn, 200, "subscriptions.json")
      end

      {:ok, response} = Subject.list(client, [:id, :contentDetails])

      assert 200 == response.status_code
    end

    test "filters unknown elements from parts list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "mine=true&part=contentDetails%2Csnippet"

        json_response(conn, 200, "subscriptions.json")
      end

      {:ok, response} = Subject.list(client, ["contentDetails", "snippet", "unknown"])

      assert 200 == response.status_code
    end

    test "accepts filter list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "channelId=hello&part=id"

        json_response(conn, 200, "subscriptions.json")
      end

      {:ok, response} = Subject.list(client, :id, %{:channelId => "hello"})

      assert 200 == response.status_code
    end

    test "filters unknown filter keys from list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "channelId=hello&part=id"

        json_response(conn, 200, "subscriptions.json")
      end

      {:ok, response} = Subject.list(client, :id, %{:channelId => "hello"})

      assert 200 == response.status_code
    end
  end
end
