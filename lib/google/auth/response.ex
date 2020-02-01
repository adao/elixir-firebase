defmodule Google.Auth.Response do
  defstruct [:idToken, :email, :refreshToken, :expiresIn, :localId]
end
