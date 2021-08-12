# EsBank

A lot code here is for example purposes and not fully or correctly implemented(lifespans and middleware for example)

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Create and migrate event store with `mix event_store.setup`
  * Start with `iex -S mix phx.server`


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

# ATM Withdrawl Command/Event flow
```
C: Teller.InitiateWithdrawl
  C: Accounts.ConfirmAuthorization
  E: Accounts.AuthorizationConfirmed
E: Teller.WithdrawInitiated
C: Teller.WithdrawMoney
  C: Accounts.WithdrawMoney
  E: Accounts.MoneyWithdrawn
E: Teller.MoneyWithdrawn
```

### Create a new account
```
acct = EsBank.Accounts.open_account(%{owner: "Peter", pin: "1234"})
```
### Deposit money into the new account
```
acct = EsBank.Accounts.deposit_money_into_account(%{account_id: acct.id, amount: 50000})
```
### Withdraw money from account via an ATM withdrawl
```
resp = EsBank.Tellers.withdraw_money_from_atm(%{account_id: acct.id, pin: "1234", amount: 10000})
```

# Dispatching command manually
```
cmd = %EsBank.Tellers.Commands.InitiateWithdrawl{account_id: acct.id, teller_id: EsBank.Tellers.Aggregates.AtmMachine.fixed_id(), amount: 10000, pin: "2468"}
EsBank.Router.dispatch(cmd, [application: EsBank.App, consistency: :strong, execution_result: true])
```

# CQRS/ES/Commanded Code Flow
```
Call a function
  Create a command
    Create command struct
    Validate command struct
  Dispatch command
    Middleware if needed
  Handle command
    Business logic checks
  Return event from handler(or multiple/no events, error, etc.)
    Internally by Commanded this is written to our event store
  (Optional)
    Event Handler / Process Manager / Projection
    Fetch some data from projection to return to the user, otherwise they'll get :ok
```

# Other Concepts
## Event Upcasting

### https://github.com/commanded/commanded/blob/master/guides/Events.md#upcasting-events

#### Change the shape of an event by renaming a field:
```
defimpl Commanded.Event.Upcaster, for: AnEvent do
  def upcast(%AnEvent{} = event, _metadata) do
    %AnEvent{name: name} = event

    %AnEvent{event | first_name: name}
  end
end
```

#### Change the type of event by replacing a historical event with a new event:
```
defimpl Commanded.Event.Upcaster, for: HistoricalEvent do
  def upcast(%HistoricalEvent{} = event, _metadata) do
    %HistoricalEvent{id: id, name: name} = event

    %NewEvent{id: id, name: name}
  end
end
```

## Snapshotting

## Rebuiding Projections

