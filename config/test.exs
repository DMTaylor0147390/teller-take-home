import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :teller_take_home, TellerTakeHome.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "teller_take_home_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :teller_take_home, TellerTakeHomeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "HR4JkzBy/tncmfi9yRUz3npBfwfC0u6UVB5/C0g7T5BSitRLqnMQUmHUh2ebOhJX",
  server: false

# In test we don't send emails.
config :teller_take_home, TellerTakeHome.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
