defmodule EsBank.Accounts.Events.MoneyDeposited do
  @derive Jason.Encoder
  defstruct [:account_id, :amount, :old_balance, :new_balance]

  alias EsBank.Accounts.Commands.DepositMoney

  def from_command(%DepositMoney{amount: amt_deposited} = cmd, old_balance, new_balance) when is_integer(old_balance) and is_integer(new_balance) and new_balance - old_balance == amt_deposited do
    %__MODULE__{
      account_id: cmd.account_id,
      amount: cmd.amount,
      old_balance: old_balance,
      new_balance: new_balance
    }
  end
end
