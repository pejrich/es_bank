defmodule EsBank.Tellers.Commands.WithdrawMoney do
  defstruct [:account_id, :amount, :old_balance, :new_balance]
  use EsBank.Support.Command

  validates :account_id, presence: true, uuid: true
  validates :amount, &valid_amount/1
  validates :old_balance, &valid_amount/1
  validates :new_balance, &valid_amount/1
end
