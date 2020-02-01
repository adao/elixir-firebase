defmodule Google.Auth do
  @api_key System.get_env("GOOGLE_AUTH_API_KEY")
  @idp_auth_url "https://identitytoolkit.googleapis.com/v1/accounts"

  def sign_up(email, password) do
    url = "#{@idp_auth_url}:signUp?key=#{@api_key}"
    {:ok, json} = Jason.encode(%{
      email: email,
      password: password,
      returnSecureToken: true
    })
    {:ok, status, _headers, client_ref} = :hackney.post(url, [], json)
    {:ok, body} = :hackney.body(client_ref)
    case status do
      200 ->
        decoded = Jason.decode!(body)
          |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
        struct(Google.Auth.Response, decoded)
      _ -> %{status: status, body: body} |> inspect |> IO.puts
    end
  end

  def sign_in(email, password) do
    url = "#{@idp_auth_url}:signInWithPassword?key=#{@api_key}"
    {:ok, json} = Jason.encode(%{
      email: email,
      password: password,
      returnSecureToken: true
    })
    {:ok, status, _headers, client_ref} = :hackney.post(url, [], json)
    {:ok, body} = :hackney.body(client_ref)
    case status do
      200 ->
        Jason.decode!(body)
          |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
      _ -> %{status: status, body: body} |> inspect |> IO.puts
    end
  end

  def destroy_user(id_token) do
    url = "#{@idp_auth_url}:delete?key=#{@api_key}"
    {:ok, json} = Jason.encode(%{idToken: id_token})
    {:ok, 200, _headers, _client_ref} = :hackney.post(url, [], json)
    :ok
  end
end
