defmodule Exyt.AuthTest do
  use ExUnit.Case, async: false

  doctest Exyt.Auth

  import Exyt.TestHelpers

  alias Exyt.{AccessToken, Client}
  alias Exyt.Auth, as: Subject

  setup do
    bypass = Bypass.open()
    client = Client.new(
      site: bypass_server(bypass),
      redirect_uri: "http://localhost",
      client_id: "id",
      client_secret: "secret"
    )
    {:ok, client: client, bypass: bypass}
  end

  describe "access_token/2" do
    test "returns successful response", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "POST", "/o/oauth2/token", fn conn ->
        json_response(conn, 200, "auth/success.json")
      end

      {:ok, %AccessToken{} = token} = Subject.access_token(client, "1234")

      assert "1/fFAGRNJru1FTz70BzhT3Zg" == token.access_token
      assert "1/xEoDL4iW3cxlI7yDbSRFYNG01kVKM2C-259HOF2aQbI" == token.refresh_token
    end

    test "returns error response when authentication fails", %{client: client, bypass: bypass} do
      Bypass.expect_once bypass, "POST", "/o/oauth2/token", fn conn ->
        json_response(conn, 401, "auth/denied.json")
      end

      {:error, _message} = Subject.access_token(client, "1234")
    end
  end
end
