defmodule EsBank.Accounts.Commands.WithdrawMoney do
  defstruct [:account_id, :amount]
  use EsBank.Support.Command

  validates :account_id, presence: true, uuid: true
  validates :amount, &valid_amount/1
end
