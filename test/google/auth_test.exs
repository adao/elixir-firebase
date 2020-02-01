defmodule Google.AuthTest do
  use ExUnit.Case
  @moduletag :external

  alias Google.Auth

  @password "Password1!"

  test "sign up user" do
    email = "#{System.unique_integer([:positive])}@firebase.com"
    resp = Auth.sign_up(email, @password)
    assert is_binary(resp.idToken)
    on_exit(fn ->
      Auth.destroy_user(resp.idToken)
    end)
  end

  describe "destroy user" do
    setup do
      email = "#{System.unique_integer([:positive])}@firebase.com"
      resp = Auth.sign_up(email, @password)
      [id_token: resp.idToken]
    end

    test "destroy user", context do
      assert :ok == Auth.destroy_user(context[:id_token])
    end
  end
end
