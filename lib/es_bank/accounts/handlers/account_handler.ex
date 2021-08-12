defmodule EsBank.Accounts.Handlers.AccountHandler do
  alias EsBank.Accounts.Aggregates.Account
  alias EsBank.Accounts.Commands.{OpenAccount, DepositMoney, WithdrawMoney}
  alias EsBank.Accounts.Events.{AccountOpened, MoneyDeposited, MoneyWithdrawn}

  @behaviour Commanded.Commands.Handler

  def handle(%Account{account_id: nil}, %OpenAccount{} = cmd) do
    AccountOpened.from_command(cmd)
  end

  def handle(%Account{}, %OpenAccount{}), do: {:error, :account_already_open}

  def handle(%Account{account_id: nil}, _), do: {:error, :account_not_open}

  def handle(%Account{balance: bal}, %DepositMoney{amount: amt} = cmd) do
    MoneyDeposited.from_command(cmd, bal, bal + amt)
  end

  def handle(%Account{balance: bal}, %WithdrawMoney{amount: amt} = cmd) when bal > amt do
    MoneyWithdrawn.from_command(cmd, bal, bal - amt)
  end

  def handle(%Account{}, %WithdrawMoney{}), do: {:error, :insufficient_funds}
end
