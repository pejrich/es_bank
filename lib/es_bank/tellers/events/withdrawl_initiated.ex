defmodule EsBank.Tellers.Events.WithdrawlInitiated do
  @derive Jason.Encoder
  defstruct [:account_id, :amount, :old_balance, :new_balance]

  alias EsBank.Tellers.Commands.InitiateWithdrawl

  def from_command(%InitiateWithdrawl{amount: amt} = cmd, old_balance, new_balance) when is_integer(old_balance) and is_integer(new_balance) and new_balance - old_balance == amt do
    %__MODULE__{
      account_id: cmd.account_id,
      amount: cmd.amount,
      old_balance: old_balance,
      new_balance: new_balance
    }
  end
end
