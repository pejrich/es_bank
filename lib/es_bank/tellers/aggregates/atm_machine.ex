defmodule EsBank.Tellers.Aggregates.AtmMachine do
  use EsBank.Support.Aggregate
  defstruct [
    teller_id: "ATM_1",
    balance: 100_000_000,
  ]

  alias EsBank.Tellers.Events.{MoneyDeposited, MoneyWithdrawn}

  ################################################################################
  ## State Mutators
  ################################################################################
  def apply(%__MODULE__{} = atm, %MoneyDeposited{} = event) do
    %__MODULE__{atm | balance: event.new_balance}
  end

  def apply(%__MODULE__{} = atm, %MoneyWithdrawn{} = event) do
    %__MODULE__{atm | balance: event.new_balance}
  end

  def apply(atm, _), do: atm
end
