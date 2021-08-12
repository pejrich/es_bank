defmodule EsBank.Support.Validators do
  def is_member(list, val) when is_list(list), do: Enum.member?(list, val)
  def is_member(_list, _val), do: false

  def is_valid_txn_type(type), do: is_member(EsBank.Accounts.Commands.WriteTransaction.txn_types, type)
  def is_valid_txn_type(_type), do: false

  def is_datetime(%{day: _, hour: _, minute: _, month: _, year: _}), do: true
  def is_datetime(_), do: false

  def valid_pin(pin) when is_binary(pin) and byte_size(pin) == 4, do: Regex.match?(~r/^[0-9]{4}$/, pin)
  def valid_pin(_), do: false


  def valid_amount(amt) when is_integer(amt) and amt > 0, do: true
  def valid_amount(_amt), do: false
end
