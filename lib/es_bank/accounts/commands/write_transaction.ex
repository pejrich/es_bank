defmodule EsBank.Accounts.Commands.WriteTransaction do
  defstruct [:txn_id, :account_id, :txn_type, :txn_data]
  use EsBank.Support.Command

  @txn_types ["DEPOSIT", "WITHDRAW"]
  def txn_types, do: @txn_types

  validates :txn_id, presence: true, uuid: true
  validates :account_id, presence: true, uuid: true
  validates :txn_type, &is_valid_txn_type/1
  validates :txn_data, &is_binary/1
end
