defmodule Firebase.JWT do
  @behaviour Firebase.JWT.Behavior
  @jwt_impl Application.fetch_env!(:firebase, :jwt_impl)

  def verify(token) do
    @jwt_impl.verify(token)
  end
end
