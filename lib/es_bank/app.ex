defmodule EsBank.App do
  use Commanded.Application, otp_app: :es_bank

  router EsBank.Router

  # Account API
  alias EsBank.Accounts
  defdelegate authenticate_account(account_id, pin), to: Accounts
  defdelegate open_account(attrs), to: Accounts
  defdelegate deposit_money_into_account(attrs), to: Accounts
  defdelegate withdraw_money_from_account(attrs), to: Accounts


  # Teller API
  alias EsBank.Tellers
  defdelegate deposit_money_into_atm(attrs), to: Tellers
  defdelegate withdraw_money_from_atm(attrs), to: Tellers
end
