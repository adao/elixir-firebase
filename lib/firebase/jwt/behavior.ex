defmodule Firebase.JWT.Behavior do
  @callback verify(String.t) :: %Firebase.IdToken{}
end
