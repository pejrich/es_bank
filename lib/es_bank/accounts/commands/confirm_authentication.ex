defmodule EsBank.Accounts.Commands.ConfirmAuthentication do
  defstruct [:account_id, :pin]
  use EsBank.Support.Command


  validates :account_id, presence: true, uuid: true
  validates :pin, &valid_pin/1
end
