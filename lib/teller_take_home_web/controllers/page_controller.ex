defmodule TellerTakeHomeWeb.PageController do
  use TellerTakeHomeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def list_accounts(conn, _params) do
    {status_code, response} = conn.req_headers
    |> TellerTakeHome.Requests.list_accounts()

    send_resp(conn, status_code, response |> Jason.encode!)
  end

  def enroll(conn, params) do
    {status_code, response} = TellerTakeHome.Requests.enroll(params, conn.req_headers)
    send_resp(conn, status_code, response)
  end

  def list_transactions(conn, params) do
    {status_code, response} = params["account"]
    |> TellerTakeHome.Requests.list_transactions(conn.req_headers)

    send_resp(conn, status_code, Jason.encode!(response))
  end
end
