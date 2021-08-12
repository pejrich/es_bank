defmodule EsBank.Router do
  use Commanded.Commands.Router

  middleware(EsBank.Support.SomeMiddleware)

  ################################################################################
  ## Account
  ################################################################################
  alias EsBank.Handlers.AccountHandler
  alias EsBank.Lifespans.AccountLifespan
  alias EsBank.Accounts.Commands.{OpenAccount, DepositMoney, WithdrawMoney}
  alias EsBank.Accounts.Aggregates.{Account}

  dispatch([OpenAccount, DepositMoney, WithdrawMoney],
    to: AccountHandler,
    lifespan: AccountLifespan,
    aggregate: Account,
    identity: :account_id
  )

  # dispatch DepositMoney, to: DepositMoneyHandler, aggregate: BankAccount, identity: :account_number

  def aggregate_for_command(command) do
    with {^command, config} <-
           Enum.find(@registered_commands, fn
             {cmd, _} when cmd == command -> true
             _ -> false
           end),
         aggregate <- Keyword.get(config, :aggregate) do
      {:ok, aggregate}
    else
      _ -> {:error, :no_command_found}
    end
  end
end
