defmodule EsBank.Repo do
  use Ecto.Repo,
    otp_app: :es_bank,
    adapter: Ecto.Adapters.Postgres
end
