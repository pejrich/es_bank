defmodule EsBank.Accounts.Events.AccountOpened do
  @derive Jason.Encoder
  defstruct [:account_id, :owner, :balance, :pin, :created_at]

  alias EsBank.Accounts.Commands.OpenAccount

  def from_command(%OpenAccount{} = cmd) do
    %__MODULE__{
      account_id: cmd.account_id,
      owner: cmd.owner,
      balance: 0,
      pin: cmd.pin,
      created_at: cmd.created_at,
    }
  end
end
