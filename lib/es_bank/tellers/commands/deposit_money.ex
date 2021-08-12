defmodule EsBank.Tellers.Commands.DepositMoney do
  defstruct [:teller_id, :account_id, :amount]
  use EsBank.Support.Command

  validates :teller_id, presence: true, uuid: true
  validates :account_id, presence: true, uuid: true
  validates :amount, &valid_amount/1
end
