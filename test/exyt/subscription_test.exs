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
        assert conn.method == "GET"

        json_response(conn, 200, "subscriptions/list.json")
      end

      {:ok, response} = Subject.list(client)

      assert 200 == response.status_code
      assert Enum.count(response.headers) > 0
    end

    test "accepts part with list of atoms", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "mine=true&part=contentDetails%2Cid"

        json_response(conn, 200, "subscriptions/list.json")
      end

      {:ok, response} = Subject.list(client, [:id, :contentDetails])

      assert 200 == response.status_code
    end

    test "filters unknown elements from parts list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "mine=true&part=contentDetails%2Csnippet"

        json_response(conn, 200, "subscriptions/list.json")
      end

      {:ok, response} = Subject.list(client, ["contentDetails", "snippet", "unknown"])

      assert 200 == response.status_code
    end

    test "accepts filter list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "channelId=hello&part=id"

        json_response(conn, 200, "subscriptions/list.json")
      end

      {:ok, response} = Subject.list(client, :id, %{:channelId => "hello"})

      assert 200 == response.status_code
    end

    test "filters unknown filter keys from list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "channelId=hello&part=id"

        json_response(conn, 200, "subscriptions/list.json")
      end

      {:ok, response} = Subject.list(client, [:id, :nope], %{:channelId => "hello"})

      assert 200 == response.status_code
    end

    test "accepts optional parameter forChannelId", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "channelId=lisa&forChannelId=test&part=id"

        json_response(conn, 200, "subscriptions/list.json")
      end

      {:ok, response} = Subject.list(client, :id, %{:channelId => "lisa"}, %{:forChannelId => "test"})

      assert 200 == response.status_code
    end

    test "accepts optional parameter as list", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "GET", "/subscriptions", fn conn ->
        assert conn.query_string == "channelId=lisa&maxResults=10&order=alphabetical&part=id"

        json_response(conn, 200, "subscriptions/list.json")
      end

      optional = [{:maxResults, 10}, {:order, "alphabetical"}]
      {:ok, response} = Subject.list(client, :id, %{:channelId => "lisa"}, optional)

      assert 200 == response.status_code
    end
  end

  describe "insert" do
    test "returns successful response", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "POST", "/subscriptions", fn conn ->
        assert List.keyfind(conn.req_headers, "authorization", 0) == {"authorization", "Bearer 1234"}
        assert conn.query_string == "part=snippet"
        assert conn.method == "POST"

        json_response(conn, 200, "subscriptions/insert.json")
      end

      {:ok, response} = Subject.insert(client, "UC_x5XG1OV2P6uZZ5FSM9Ttw")
      assert 200 == response.status_code
    end

    test "prepares the body string as JSON", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "POST", "/subscriptions", fn conn ->
        assert {:ok, body, _} = Plug.Conn.read_body(conn)
        assert body == "{\"snippet\":{\"resourceId\":{\"kind\":\"youtube#channel\",\"channelId\":\"UC_x5XG1OV2P6uZZ5FSM9Ttw\"}}}"

        json_response(conn, 200, "subscriptions/insert.json")
      end

      {:ok, response} = Subject.insert(client, "UC_x5XG1OV2P6uZZ5FSM9Ttw")
      assert 200 == response.status_code
    end
  end
end
