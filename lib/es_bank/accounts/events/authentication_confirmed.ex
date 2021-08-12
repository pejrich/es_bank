defmodule EsBank.Accounts.Events.AuthenticationConfirmed do
  @derive Jason.Encoder
  defstruct [:account_id]

  alias EsBank.Accounts.Commands.ConfirmAuthentication

  def from_command(%ConfirmAuthentication{} = cmd) do
    %__MODULE__{account_id: cmd.account_id}
  end
end
