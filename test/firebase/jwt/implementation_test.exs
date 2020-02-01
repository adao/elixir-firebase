defmodule Firebase.JWT.ImplementationTest do
  use ExUnit.Case
  @moduletag :external

  alias Firebase.JWT.Implementation
  alias Google.Auth

  setup_all do
    {:ok, _pid} = start_supervised(Implementation)
    :ok
  end

  setup do
    email = "#{:random.uniform}@firebase.com"
    resp = Auth.sign_up(email, "Password1!")
    on_exit(fn ->
      Auth.destroy_user(resp.idToken)
    end)
    [
      id_token: resp.idToken,
      email: email
    ]
  end

  test "verify token", context do
    data = Implementation.verify(context[:id_token])
    assert data.email == context[:email]
  end
end
