defmodule FirebaseTest do
  use ExUnit.Case
  doctest Firebase

  test "greets the world" do
    assert Firebase.hello() == :world
  end
end
