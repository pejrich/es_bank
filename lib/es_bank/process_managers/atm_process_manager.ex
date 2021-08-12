defmodule EsBank.ProcessMangers.AtmProcessManager do
  use Commanded.ProcessManagers.ProcessManager,
    application: EsBank.App,
    name: __MODULE__

  require Logger

  @derive Jason.Encoder
  defstruct [:state]

  ################################################################################
  ## Process Routing
  ################################################################################
  def interested?(%EsBank.Tellers.Events.WithdrawlInitiated{account_id: acct_id}), do: {:start, acct_id}
  def interested?(%EsBank.Accounts.Events.MoneyWithdrawn{account_id: acct_id}), do: {:continue, acct_id}
  def interested?(%EsBank.Tellers.Events.MoneyWithdrawn{account_id: acct_id}), do: {:stop, acct_id}
  def interested?(_), do: false

  ################################################################################
  ## Command Dispatch
  ################################################################################
  def handle(%__MODULE__{}, %EsBank.Tellers.Events.WithdrawlInitiated{} = event) do
    cmd = %EsBank.Tellers.Commands.WithdrawMoney{account_id: event.account_id, amount: event.amount, teller_id: EsBank.Tellers.Aggregates.AtmMachine.fixed_id()}
    case EsBank.Tellers.Commands.WithdrawMoney.validate(cmd) do
      {:ok, cmd} -> cmd
      errors -> Logger.error("Unable to dispatch WithdrawMoney command from AtmProcessManager #{inspect errors}")
    end
  end

  ################################################################################
  ## State Mutators
  ################################################################################
  def apply(%__MODULE__{} = man, %EsBank.Tellers.Events.WithdrawlInitiated{}) do
    %__MODULE__{man | state: :withdrawl_initiated}
  end

  def apply(%__MODULE__{} = man, %EsBank.Accounts.Events.MoneyWithdrawn{}) do
    %__MODULE__{man | state: :money_withdrawn_from_account}
  end

  def apply(%__MODULE__{} = man, %EsBank.Tellers.Events.MoneyWithdrawn{}) do
    %__MODULE__{man | state: :withdrawl_completed}
  end

  ################################################################################
  ## Error Handlers
  ################################################################################
  def error({:error, failure}, _failed_message, %{context: _context}) do
    {:stop, failure}
  end
end
