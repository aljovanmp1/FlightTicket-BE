import Config

# Do not print debug messages in production
config :logger, level: :info

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

config :ticket_BE, Ticket_BE.Repo,
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PWD"),
  hostname: System.get_env("DATABASE_HOSTNAME"),
  database: System.get_env("DATABASE_DBNAME"),
  ssl: true,
  ssl_opts: [
    server_name_indication: System.get_env("DATABASE_INDICATION"),
    verify: :verify_none
  ],
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :ticket_BE, Ticket_BEWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: System.get_env("SECRET_KEY_BASE"),
  watchers: []
