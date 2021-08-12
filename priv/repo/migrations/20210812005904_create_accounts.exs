defmodule EsBank.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :owner, :string
      add :pin, :string
      add :balance, :integer

      timestamps()
    end
  end
end
