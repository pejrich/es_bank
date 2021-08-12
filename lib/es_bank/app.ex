defmodule EsBank.App do
  use Commanded.Application, otp_app: :es_bank

  router EsBank.Router

  @default_router_config [application: EsBank.App, consistency: :strong]

  # Account API
  alias EsBank.Accounts.Commands.{OpenAccount, DepositMoney, WithdrawMoney}

  def authenticate_account(account_id, pin) do
    case EsBank.Repo.get_by(Account, id: account_id, pin: pin) do
      nil -> false
      _ -> true
    end
  end

  def open_account(%{owner: _, pin: _} = args) do
    uuid = UUID.uuid4()

    args
    |> Map.merge(%{account_id: uuid, created_at: DateTime.utc_now()})
    |> handle_command_and_get(OpenAccount, uuid)
  end

  def deposit_money(attrs) do
    handle_command_and_get(attrs, DepositMoney, attrs[:account_id])
  end

  def withdraw_money(attrs) do
    handle_command_and_get(attrs, WithdrawMoney, attrs[:account_id])
  end

  # Teller API
  alias EsBank.Tellers.Commands.{InitiateDeposit, InitiateWithdraw}

  def deposit_money(attrs) do
    handle_command(attrs, DepositMoney, execution_result: true)
  end

  def withdraw_money(attrs) do
    handle_command(attrs, WithdrawMoney, execution_result: true)
  end

  # Transaction API
  alias EsBank.Accounts.Commands.{WriteTransaction}

  def write_transaction(attrs) do
    uuid = UUID.uuid4()

    attrs
    |> Map.merge(%{txn_id: uuid})
    |> handle_command_and_get(WriteTransaction, uuid)
  end

  ################################################################################
  ## Private Helpers
  ################################################################################
  defp handle_command(args, command, config \\ []) do
    args
    |> command.new
    |> command.validate
    |> dispatch_command(config)
  end

  defp handle_command_and_get(args, command, uuid, config \\ []) do
    args
    |> handle_command(command, config)
    |> get(command, uuid)
  end

  defp get(:ok, command, uuid) do
    command
    |> schema_for_command
    |> case do
      {:ok, schema} -> EsBank.Repo.get(schema, uuid)
      err -> err
    end
  end

  defp get(err, _, _), do: err

  defp dispatch_command({:error, _} = error, _config), do: error
  defp dispatch_command({:ok, command}, config) do
    EsBank.Router.dispatch(command, Map.merge(@default_router_config, config))
  end

  defp schema_for_command(command) do
    with {:ok, agg} <- EsBank.Router.aggregate_for_command(command),
    {:ok, schema} <- agg.schema do
      {:ok, schema}
    else
      _ -> {:error, :schema_not_found}
  end
end
end
