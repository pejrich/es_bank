defmodule EsBank.Tellers.Events.DepositInitiated do
  @derive Jason.Encoder
  defstruct [:teller_id, :account_id, :amount]

  alias EsBank.Tellers.Commands.InitiateDeposit

  def from_command(%InitiateDeposit{} = cmd) do
    %__MODULE__{
      teller_id: cmd.teller_id,
      account_id: cmd.account_id,
      amount: cmd.amount,
    }
  end
end
