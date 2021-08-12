defmodule EsBank.Accounts.Events.MoneyWithdrawn do
  @derive Jason.Encoder
  defstruct [:account_id, :amount, :old_balance, :new_balance]

  alias EsBank.Accounts.Commands.WithdrawMoney

  def from_command(%WithdrawMoney{amount: amt_withdrawn} = cmd, old_balance, new_balance) when is_integer(old_balance) and is_integer(new_balance) and old_balance - new_balance == amt_withdrawn do
    %__MODULE__{
      account_id: cmd.account_id,
      amount: cmd.amount,
      old_balance: old_balance,
      new_balance: new_balance
    }
  end
end
