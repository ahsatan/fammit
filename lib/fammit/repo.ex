defmodule Fammit.Repo do
  use Ecto.Repo,
    otp_app: :fammit,
    adapter: Ecto.Adapters.Postgres
end
