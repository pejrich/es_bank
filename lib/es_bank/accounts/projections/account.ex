defmodule EsBank.Accounts.Projections.Account do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @timestamps_opts [type: :utc_datetime_usec]

  schema "accounts" do
    field :balance, :integer
    field :owner, :string
    field :pin, :string

    timestamps()
  end
end
