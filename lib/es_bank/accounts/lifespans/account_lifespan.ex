defmodule EsBank.Lifespans.AccountLifespan do
  @behaviour Commanded.Aggregates.AggregateLifespan

  # def after_event(%MoneyDeposited{}), do: :timer.hours(1)
  # def after_event(%BankAccountClosed{}), do: :stop
  def after_event(_event), do: :infinity

  # def after_command(%CloseAccount{}), do: :stop
  def after_command(_command), do: :infinity

  # def after_error(:invalid_initial_balance), do: :timer.minutes(5)
  def after_error(_error), do: :stop
end
