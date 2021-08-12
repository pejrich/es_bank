defmodule EsBank.EventHandlers.AccountEventHandler do
  use Commanded.Event.Handler,
    application: EsBank.App,
    name: "AccountEventHandler"

    alias EsBank.Accounts.Events.{MoneyDeposited, MoneyWithdrawn}

  def handle(%MoneyDeposited{} = cmd, _metadata) do
    EsBank.App.write_transaction(%{account_id: cmd.account_id, txn_type: "DEPOSIT", txn_data: "#{cmd.amount} deposited."})
    :ok
  end

  def handle(%MoneyWithdrawn{} = cmd, _metadata) do
    EsBank.App.write_transaction(%{account_id: cmd.account_id, txn_type: "WITHDRAW", txn_data: "#{cmd.amount} withdrawn."})
    :ok
  end
end
