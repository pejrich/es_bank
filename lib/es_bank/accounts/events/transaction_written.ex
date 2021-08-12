defmodule EsBank.Accounts.Events.TransactionWritten do
  @derive Jason.Encoder
  defstruct [:txn_id, :account_id, :txn_type, :txn_data]

  alias EsBank.Accounts.Commands.WriteTransaction

  def from_command(%WriteTransaction{} = cmd) do
    %__MODULE__{
      txn_id: cmd.txn_id,
      account_id: cmd.account_id,
      txn_type: cmd.txn_type,
      txn_data: cmd.txn_data,
    }
  end
end
