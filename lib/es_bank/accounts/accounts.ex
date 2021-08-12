defmodule EsBank.Accounts do
  use EsBank.Support.Domain

  alias EsBank.Accounts.Projections.Account

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

  def deposit_money_into_account(attrs) do
    handle_command_and_get(attrs, DepositMoney, attrs[:account_id])
  end

  def withdraw_money_from_account(attrs) do
    handle_command_and_get(attrs, WithdrawMoney, attrs[:account_id])
  end
end
