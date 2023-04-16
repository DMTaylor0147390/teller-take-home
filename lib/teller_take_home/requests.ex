defmodule TellerTakeHome.Requests do

  defp base_url(url \\ nil) do
    url || "test.teller.engineering"
  end

  defp url(route \\ "") do
    base_url("https://test.teller.engineering") <> route
  end

  defp get_device_id() do
    "WXUOP2GPGJF7AAVB"
  end

  defp username(s \\ nil) do
    s || "yellow_molly"
  end

  defp password(p \\ nil) do
    p || "democraticpeoplesrepublicofkorea"
  end

  defp api_key(k \\ nil) do
    k || "HowManyGenServersDoesItTakeToCrackTheBank?"
  end

  defp path_to_keys(path) do
    %{"/signin/mfa" => ["teller-mission", "user-agent", "api-key", "device-id", "r-token", "f-token", "content-type", "accept"],
      "/signin/mfa/verify" => ["teller-mission", "user-agent", "api-key", "device-id", "r-token", "f-token", "content-type", "accept"]}
    |> Map.get(path, ["teller-mission", "user-agent", "api-key", "device-id", "r-token", "f-token", "content-type", "accept"])
  end

  defp hash_pw(password) do
    password |> Base.encode16 |> String.downcase
  end

  defp hash_username_and_pw(username, password) do
    "#{username}:#{hash_pw(password)}" |> Base.encode64
  end

  defp store_a_token(a_token, basic_auth) when is_binary(basic_auth) do
    [username, password] = basic_auth |> Base.decode64! |> String.split(":")
    store_a_token(a_token, %{"username" => username, "password" => password})
  end

  defp store_a_token(a_token, %{"username" => username, "password" => password}) do
    if !File.exists?("tokens.txt") do
      File.touch!("tokens.txt")
      File.write!("tokens.txt", Jason.encode!(%{}))
    end

    current_token_data = File.read!("tokens.txt") |> Jason.decode!()
    data = %{"token"        => a_token,
             "invalidation" => :os.system_time(:millisecond) + :timer.minutes(10)}

    new_token_data = current_token_data
    |> Map.put(hash_username_and_pw(username, password), data)

    File.write!("tokens.txt", new_token_data |> Jason.encode!())
  end

  defp get_a_token(basic_auth_token) do
    if File.exists?("tokens.txt") do
      [username, password] = basic_auth_token |> Base.decode64!() |> String.split(":")
      hash = hash_username_and_pw(username, password)
      Map.get(File.read!("tokens.txt") |> Jason.decode!(), hash)
    end
  end

  defp parse_f_token_spec(spec, data) do
    transformed_spec = spec
    |> Base.decode64!
    |> String.replace("last-request-id", data["last-request-id"])
    |> String.replace("username", data["username"] |> username())
    |> String.replace("device-id", data["device-id"] || get_device_id())
    |> String.replace("api-key", data["api-key"] |> api_key())
    |> String.replace("sha-256-b64-np(", "")
    |> String.replace(")", "")

    :crypto.hash(:sha256, transformed_spec)
    |> Base.encode64(padding: false)
  end

  defp headers(_, "/signin") do
    [{"content-type", "application/json"},
     {"device-id", get_device_id()},
     {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
     {"accept", "application/json"},
     {"user-agent", "Teller Bank iOS 2.0"}]
  end

  defp headers(_, "/signin/token") do
    [{"content-type", "application/json"},
     {"device-id", get_device_id()},
     {"api-key", "HowManyGenServersDoesItTakeToCrackTheBank?"},
     {"accept", "application/json"},
     {"user-agent", "Teller Bank iOS 2.0"}]
  end

  defp headers(headers, path = "/signin/mfa") do
    headers = headers |> Map.new()

    headers
    |> Map.put("f-token", parse_f_token_spec(headers["f-token-spec"], %{"last-request-id" => headers["f-request-id"]} |> Map.merge(headers)))
    |> Map.put("device-id", get_device_id())
    |> Map.put("api-key", api_key())
    |> Map.put("teller-mission", "accepted!")
    |> Map.put("accept", "application/json")
    |> Map.put("content-type", "application/json")
    |> Map.put("user-agent", "Teller Bank iOS 2.0")
    |> Map.take(path_to_keys(path))
    |> Enum.to_list()
  end

  defp headers(headers, path = "/signin/mfa/verify") do
    headers = headers |> Map.new()

    headers
    |> Map.put("f-token", parse_f_token_spec(headers["f-token-spec"], %{"last-request-id" => headers["f-request-id"]} |> Map.merge(headers)))
    |> Map.put("device-id", get_device_id())
    |> Map.put("api-key", api_key())
    |> Map.put("teller-mission", "accepted!")
    |> Map.put("accept", "application/json")
    |> Map.put("content-type", "application/json")
    |> Map.put("user-agent", "Teller Bank iOS 2.0")
    |> Map.take(path_to_keys(path))
    |> Enum.to_list()
  end

  defp headers(headers, path = "/accounts") do
    headers = headers |> Map.new()

    headers
    |> Map.put("f-token", parse_f_token_spec(headers["f-token-spec"], %{"last-request-id" => headers["f-request-id"]} |> Map.merge(headers)))
    |> Map.put("device-id", get_device_id())
    |> Map.put("api-key", api_key())
    |> Map.put("teller-mission", "accepted!")
    |> Map.put("accept", "application/json")
    |> Map.put("content-type", "application/json")
    |> Map.put("user-agent", "Teller Bank iOS 2.0")
    |> Map.take(path_to_keys(path) ++ ["s-token"])
    |> Enum.to_list()
  end


  defp headers(headers, path = "/accounts/" <> id) do
    headers = headers |> Map.new()

    headers
    |> Map.put("f-token", parse_f_token_spec(headers["f-token-spec"], %{"last-request-id" => headers["f-request-id"]} |> Map.merge(headers)))
    |> Map.put("device-id", get_device_id())
    |> Map.put("api-key", api_key())
    |> Map.put("teller-mission", "accepted!")
    |> Map.put("accept", "application/json")
    |> Map.put("content-type", "application/json")
    |> Map.put("user-agent", "Teller Bank iOS 2.0")
    |> Map.take(path_to_keys(path) ++ ["s-token"])
    |> Enum.to_list()
  end


  defp signin(data = %{"username" => _username, "password" => _password}, headers) do
    path = "/signin"

    url(path)
    |> HTTPoison.post!(Jason.encode!(data), headers |> headers(path))
  end

  defp signin_mfa(data = %{"device_id" => _device_id}, headers) do
    path = "/signin/mfa"
    url(path)
    |> HTTPoison.post!(Jason.encode!(data), headers |> headers(path))
  end

  defp signin_mfa_verify(data = %{"code" => _code}, headers) do
    path = "/signin/mfa/verify"

    url(path)
    |> HTTPoison.post!(Jason.encode!(data), headers |> headers(path))
  end

  defp signin_token(data = %{"token" => _token}, headers) do
    path = "/signin/token"

    url(path)
    |> HTTPoison.post!(Jason.encode!(data), headers |> headers(path))
  end

  defp get_account_balances(account_id, headers) do
    path = "/accounts/#{account_id}/balances"

    url(path)
    |> HTTPoison.get!(headers |> headers(path))
  end

  defp get_account_details(account_id, headers) do
    path = "/accounts/#{account_id}/details"

    url(path)
    |> HTTPoison.get!(headers |> headers(path))
  end

  defp get_account_transactions(account_id, headers) do
    path = "/accounts/#{account_id}/transactions"

    url(path)
    |> HTTPoison.get!(headers |> headers(path))
  end

  def enroll(data, headers) do
    if not Enum.all?(["username", "password", "device_type"], fn s -> Map.has_key?(data, s) end) do
      raise("The data #{inspect data} does not contain all the needed data")
    end

    signin_response = signin(data |> Map.take(["username", "password"]), headers)

    device_id = signin_response
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("data")
    |> Map.get("devices")
    |> Enum.map(fn m -> {m["type"], m["id"]} end)
    |> Map.new()
    |> Map.get(data["device_type"])

    mfa_response = signin_mfa(%{"device_id" => device_id}, signin_response.headers)

    mfa_verify_response = signin_mfa_verify(%{"code" => "123456"}, mfa_response.headers)

    mfa_verify_response
    |> Map.get(:body)
    |> Jason.decode!()
    |> Map.get("data")
    |> Map.get("a_token")
    |> store_a_token(data |> Map.take(["username", "password"]))

    {200, "User enrolled"}
  end

  defp get_basic_auth(headers) do
    headers
    |> Map.new()
    |> Map.get("authorization")
    |> String.replace("Basic ", "")
  end

  def list_accounts(headers) do
    auth = get_basic_auth(headers)
    token_map = get_a_token(auth)

    token_signin_response = signin_token(%{"token" => token_map["token"]}, headers("", "/signin/token"))
    case token_signin_response.status_code do
      x when x >= 400 -> {x, "You must re-enroll in order to continue."}
      200 ->
        store_a_token(token_signin_response.body |> Jason.decode! |> Map.get("data") |> Map.get("a_token"), auth)
        response = token_signin_response.body
        |> Jason.decode!()
        |> Map.get("data")
        |> Map.get("accounts")
        |> Map.values()
        |> List.flatten()
        |> Enum.map(fn m -> {m["id"], get_account_balances(m["id"], token_signin_response.headers) |> Map.get(:body) |> Jason.decode!} end)
        |> Map.new()
        {200, response}
      c   -> {c, "There was an unexpected error."}
    end
  end

  def list_transactions(account_id, headers) do
    auth = get_basic_auth(headers)
    token_map = get_a_token(auth)

    token_signin_response = signin_token(%{"token" => token_map["token"]}, headers("", "/signin/token"))
    case token_signin_response.status_code do
      x when x >= 400 -> {x, "You must re-enroll in order to continue."}
      200 ->
        store_a_token(token_signin_response.body |> Jason.decode! |> Map.get("data") |> Map.get("a_token"), auth)
        response = get_account_transactions(account_id, token_signin_response.headers)
        |> Map.get(:body)
        |> Jason.decode!()
        {200, response}

      c   -> {c, "There was an unexpected error."}
    end
  end

end
