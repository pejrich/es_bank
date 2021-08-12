defmodule EsBank.Tellers.Handlers.AtmMachineHandler do
  alias EsBank.Tellers.Aggregates.AtmMachine
  alias EsBank.Tellers.Commands.{InitiateWithdrawl, DepositMoney, WithdrawMoney}
  alias EsBank.Tellers.Events.{WithdrawlInitiated, MoneyDeposited, MoneyWithdrawn}

  @behaviour Commanded.Commands.Handler

  def handle(%AtmMachine{}, %InitiateWithdrawl{} = cmd) do
    with true <- EsBank.Accounts.authenticate_account(cmd.account_id, cmd.pin) do
      WithdrawlInitiated.from_command(cmd)
    else
      _ -> {:error, :unable_to_authenticate_user}
    end
  end

  def handle(%AtmMachine{balance: bal}, %DepositMoney{amount: amt}) when bal < amt do
    {:error, :atm_insufficient_funds}
  end

  def handle(%AtmMachine{}, %DepositMoney{amount: amt} = cmd) do
    with :ok <- EsBank.App.deposit_money_into_account(%{account_id: cmd.account_id, amount: amt}) do
      MoneyDeposited.from_command(cmd)
    else
      _ -> :ok
    end
  end

  def handle(%AtmMachine{balance: bal}, %WithdrawMoney{amount: amt}) when bal < amt do
    {:error, :atm_insufficient_funds}
  end

  def handle(%AtmMachine{}, %WithdrawMoney{amount: amt} = cmd) do
    attrs = %{account_id: cmd.account_id, amount: amt}
    command = EsBank.Accounts.Commands.WithdrawMoney.new(attrs)

    with :ok <- EsBank.Accounts.dispatch_command(command) do
      MoneyWithdrawn.from_command(cmd)
    else
      {:error, _err} = error -> error
      x -> IO.puts("\n\n\n\n\n breakdown \n\n\n\n\n"); IO.inspect(x); {:error, :unknown_error_withdrawing_money}
    end
  end

  def handle(%AtmMachine{}, %WithdrawMoney{}), do: {:error, :insufficient_funds}

  def handle(_, _), do: {:error, :unknown_errors}
end
