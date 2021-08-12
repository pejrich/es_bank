defmodule EsBank.Tellers.Aggregates.AtmMachine do
  use EsBank.Support.Aggregate

  @fixed_id "1c915dd1-8bf0-4662-a2ce-60725b0c7de2" # "ATM_1"
  def fixed_id, do: @fixed_id

  defstruct [
    teller_id: @fixed_id,
    balance: 100_000_000,
  ]

  alias EsBank.Tellers.Events.{MoneyDeposited, MoneyWithdrawn}

  ################################################################################
  ## State Mutators
  ################################################################################
  def apply(%__MODULE__{} = atm, %MoneyDeposited{} = event) do
    %__MODULE__{atm | balance: atm.balance + event.amount}
  end

  def apply(%__MODULE__{} = atm, %MoneyWithdrawn{} = event) do
    %__MODULE__{atm | balance: atm.balance - event.amount}
  end

  def apply(atm, _), do: atm
end
