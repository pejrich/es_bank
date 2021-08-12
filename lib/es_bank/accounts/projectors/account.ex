defmodule EsBank.Accounts.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: EsBank.App,
    repo: EsBank.Repo,
    name: "Accounts.Projectors.Account",
    consistency: :strong

  alias EsBank.Accounts.Events.{
    AccountOpened,
    MoneyDeposited,
    MoneyWithdrawn
  }

  alias EsBank.Repo
  alias EsBank.Accounts.Projections.Account

  project(%AccountOpened{} = event, _metadata, fn multi ->
    {:ok, created_at, _} = DateTime.from_iso8601(event.created_at)
    Ecto.Multi.insert(multi, :account, %Account{
      id: event.account_id,
      owner: event.owner,
      pin: event.pin,
      balance: event.balance,
      inserted_at: created_at,
    })
  end)

  project(%MoneyDeposited{} = event, _metadata, fn multi ->
    attrs = Map.from_struct(event)
    attrs = Map.merge(attrs, %{balance: attrs.new_balance})
    find_and_update(event.account_id, multi, attrs, :money_deposited)
  end)

  project(%MoneyWithdrawn{} = event, _metadata, fn multi ->
    attrs = Map.from_struct(event)
    attrs = Map.merge(attrs, %{balance: attrs.new_balance})
    find_and_update(event.account_id, multi, attrs, :money_withdrawn)
  end)

  defp find_and_update(id, multi, map, name) do
    case Repo.get(Account, id) do
      nil -> multi
      acct -> Ecto.Multi.update(multi, name, update_changeset(acct, map))
    end
  end

  defp update_changeset(acct, map) do
    fields = EsBank.Accounts.Projections.Account.__schema__(:fields)
    Ecto.Changeset.cast(acct, map, fields)
  end
end
