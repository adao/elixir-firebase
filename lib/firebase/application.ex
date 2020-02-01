defmodule Firebase.Application do
  use Application

  def start(_type, _args) do
    children = [
      Firebase.JWT.Implementation
    ]
    opts = [strategy: :one_for_one, name: Firebase.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
