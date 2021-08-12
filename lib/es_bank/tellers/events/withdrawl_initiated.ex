defmodule EsBank.Tellers.Events.WithdrawlInitiated do
  @derive Jason.Encoder
  defstruct [:teller_id, :account_id, :amount]

  alias EsBank.Tellers.Commands.InitiateWithdrawl

  def from_command(%InitiateWithdrawl{} = cmd) do
    %__MODULE__{
      teller_id: cmd.teller_id,
      account_id: cmd.account_id,
      amount: cmd.amount,
    }
  end
end
