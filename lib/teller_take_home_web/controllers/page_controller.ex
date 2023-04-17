defmodule TellerTakeHomeWeb.PageController do
  use TellerTakeHomeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def list_accounts(conn, _params) do
    {status_code, response} = try do
                                conn.req_headers
                                |> TellerTakeHome.Requests.list_accounts()
                              rescue
                                e -> {500, inspect(e)}
                              end

    send_resp(conn, status_code, response |> Jason.encode!)
  end

  def enroll(conn, params) do
    {status_code, response} = try do
                                TellerTakeHome.Requests.enroll(params, conn.req_headers)
                              rescue
                                e -> {500, inspect(e)}
                              end
    send_resp(conn, status_code, response)
  end

  def list_transactions(conn, params) do
    {status_code, response} = try do
                                params["account"]
                                |> TellerTakeHome.Requests.list_transactions(conn.req_headers)
                              rescue
                                e -> {500, inspect(e)}
                              end
    send_resp(conn, status_code, Jason.encode!(response))
  end
end
