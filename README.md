# EsBank

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

Example EventStore Row:

```
event_id: 453c94a2-250b-45b4-aa90-24d0fd63e734
event_type: Elixir.EsBank.Accounts.Events.AccountOpened
causation_id: cc1751d2-99bb-42a1-a17a-8cf6b8c97fe3
correlation_id: d19438b2-9f0e-4978-b654-0fd59bdca53c
data: BINARY_JSON_DATA
metadata: BINARY_JSON_DATA
created_at: 2021-08-11 19:00:03.186651-07
```

acct = EsBank.Accounts.open_account(%{owner: "Peter", pin: "1234"})
acct = EsBank.Accounts.deposit_money_into_account(%{account_id: acct.id, amount: 50000})
resp = EsBank.Tellers.withdraw_money_from_atm(%{account_id: acct.id, pin: "1234", amount: 10000})

cmd = %EsBank.Tellers.Commands.InitiateWithdrawl{account_id: acct.id, teller_id: EsBank.Tellers.Aggregates.AtmMachine.fixed_id(), amount: 10000, pin: "2468"}
EsBank.Router.dispatch(cmd, [application: EsBank.App, consistency: :strong, execution_result: true])

Teller.InitiateWithdrawl
  Accounts.ConfirmAuthorization
  Accounts.AuthorizationConfirmed
Teller.WithdrawInitiated
Teller.WithdrawMoney
  Accounts.WithdrawMoney
  Accounts.MoneyWithdrawn
Teller.MoneyWithdrawn