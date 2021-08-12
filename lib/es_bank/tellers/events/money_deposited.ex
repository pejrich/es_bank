defmodule EsBank.Tellers.Events.MoneyDeposited do
  @derive Jason.Encoder
  defstruct [:teller_id, :account_id, :amount]

  alias EsBank.Tellers.Commands.DepositMoney

  def from_command(%DepositMoney{} = cmd) do
    %__MODULE__{
      teller_id: cmd.teller_id,
      account_id: cmd.account_id,
      amount: cmd.amount,
    }
  end
end
