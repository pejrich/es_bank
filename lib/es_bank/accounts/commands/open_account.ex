defmodule EsBank.Accounts.Commands.OpenAccount do
  defstruct [:account_id, :owner, :created_at, :pin]
  use EsBank.Support.Command


  validates :account_id, presence: true, uuid: true
  validates :owner, &is_binary/1
  validates :created_at, &is_datetime/1
  validates :pin, &valid_pin/1
end
