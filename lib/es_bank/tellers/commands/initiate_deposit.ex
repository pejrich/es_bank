defmodule EsBank.Tellers.Commands.InitiateDeposit do
  defstruct [:teller_id, :account_id, :pin, :amount]
  use EsBank.Support.Command

  validates :teller_id, presence: true, uuid: true
  validates :account_id, presence: true, uuid: true
  validates :pin, &valid_pin/1
  validates :amount, &valid_amount/1
end
