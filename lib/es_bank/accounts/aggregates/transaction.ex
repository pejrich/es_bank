defmodule EsBank.Accounts.Aggregates.Transaction do
  use EsBank.Support.Aggregate
  defstruct [:txn_id, :account_id, :txn_type, :txn_data]

  alias EsBank.Accounts.Events.{TransactionWritten}

  ################################################################################
  ## State Mutators
  ################################################################################
  def apply(%__MODULE__{} = acct, %TransactionWritten{} = event) do
    %__MODULE__{acct |
      txn_id: event.txn_id,
      account_id: event.account_id,
      txn_type: event.txn_type,
      txn_data: event.txn_data,
    }
  end
end
