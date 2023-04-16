defmodule TellerTakeHome.Repo do
  use Ecto.Repo,
    otp_app: :teller_take_home,
    adapter: Ecto.Adapters.Postgres
end
