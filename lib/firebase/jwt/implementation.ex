defmodule Firebase.JWT.Implementation do
  @behaviour Firebase.JWT.Behavior
  @moduledoc """
  Documentation for VerifyJwt.
  """
  use Agent

  @cert_url "https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com"

  def start_link(_opts) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def verify(token) do
    jwk = get_jwk_for_token(token)
    {true, jose_jwt, _} = JOSE.JWT.verify(jwk, token)
    id_token = JOSE.JWT.to_map(jose_jwt)
      |> elem(1)
      |> Enum.map(fn {key, val} -> {String.to_atom(key), val} end)
    struct(Firebase.IdToken, id_token)
  end

  defp get_jwk_for_token(token) do
    kid = JOSE.JWT.peek_protected(token).fields["kid"]
    jwks = get_jwks()
    jwks[kid] |> JOSE.JWK.to_map |> elem(1)
  end

  defp get_jwks do
    Agent.get(__MODULE__, fn map -> map end)
      |> get_jwks
  end

  defp get_jwks(%{}) do
    fetch_jwks()
  end

  defp get_jwks(%{jwks: jwks, expires: expires}) do
    if expires < Utils.Time.unix_epoch_in_seconds() do
      jwks
    else
      fetch_jwks()
    end
  end

  defp fetch_jwks do
    {:ok, 200, headers, client_ref} = :hackney.get(@cert_url)
    {:ok, body} = :hackney.body(client_ref)
    certs = Jason.decode!(body)
    jwks = JOSE.JWK.from_firebase(certs)
    expires = get_max_age(headers) + Utils.Time.unix_epoch_in_seconds()
    :ok = Agent.update(__MODULE__, fn _ -> %{jwks: jwks, expires: expires} end)
    jwks
  end

  defp get_max_age(headers) do
    headers
      |> Enum.find(&(String.match?(elem(&1,0), ~r/cache-control/i)))
      |> elem(1)
      |> String.split(~r/\s*,\s*/)
      |> Enum.find(&(String.starts_with?(&1, "max-age")))
      |> String.split("=")
      |> Enum.at(1)
      |> String.to_integer()
  end
end
