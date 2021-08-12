defmodule EsBank.Accounts.Aggregates.Account do
  use EsBank.Support.Aggregate
  defstruct [:account_id, :owner, :balance, :pin, :created_at]

  alias EsBank.Accounts.Events.{AccountOpened, MoneyDeposited, MoneyWithdrawn}

  ################################################################################
  ## State Mutators
  ################################################################################
  def apply(%__MODULE__{} = acct, %AccountOpened{} = event) do
    %__MODULE__{acct |
      account_id: event.account_id,
      owner: event.owner,
      pin: event.pin,
      balance: event.balance,
      created_at: event.created_at,
    }
  end

  def apply(%__MODULE__{} = acct, %MoneyDeposited{} = event) do
    %__MODULE__{acct | balance: event.new_balance}
  end

  def apply(%__MODULE__{} = acct, %MoneyWithdrawn{} = event) do
    %__MODULE__{acct | balance: event.new_balance}
  end
end
