defmodule Bankoo.Repo do
  use Ecto.Repo,
    otp_app: :bankoo,
    adapter: Ecto.Adapters.Postgres
end
