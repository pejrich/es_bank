defmodule EsBank.Tellers do
  use EsBank.Support.Domain

  alias EsBank.Tellers.Commands.{InitiateDeposit, InitiateWithdrawl}

  def deposit_money_into_atm(attrs) do
    attrs
    |> Map.merge(%{teller_id: EsBank.Tellers.Aggregates.AtmMachine.fixed_id()})
    |> handle_command(InitiateDeposit, execution_result: true)
  end

  def withdraw_money_from_atm(attrs) do
    with :ok <-
           attrs
           |> Map.merge(%{teller_id: EsBank.Tellers.Aggregates.AtmMachine.fixed_id()})
           |> handle_command(InitiateWithdrawl, execution_result: true) do
      get(EsBank.Accounts.Projections.Account, attrs[:account_id])
    else
      error -> error
    end
  end
end
