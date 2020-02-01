defmodule Firebase.IdToken do
  defstruct [:email, :email_verified, :auth_time, :exp, :iat, :sub, :iss]
end
