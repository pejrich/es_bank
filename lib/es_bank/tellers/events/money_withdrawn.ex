defmodule EsBank.Tellers.Events.MoneyWithdrawn do
  @derive Jason.Encoder
  defstruct [:teller_id, :account_id, :amount]

  alias EsBank.Tellers.Commands.WithdrawMoney

  def from_command(%WithdrawMoney{} = cmd) do
    %__MODULE__{
      teller_id: cmd.teller_id,
      account_id: cmd.account_id,
      amount: cmd.amount
    }
  end
end
