defmodule Exyt.AccessTokenTest do
  use ExUnit.Case, async: false

  doctest Exyt.AccessToken

  alias Exyt.AccessToken, as: Subject

  test "new with binary" do
    token = Subject.new("1234")

    assert "1234" == token.access_token
  end

  test "new with map of properties" do
    token = Subject.new(%{access_token: "1234", refresh_token: "abcd"})

    assert "1234" == token.access_token
    assert "abcd" == token.refresh_token
  end
end
