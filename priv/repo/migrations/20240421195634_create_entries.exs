defmodule Bankoo.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :user_id, :integer
      add :type, :string
      add :amount, :integer
      add :transaction_id, references(:transactions, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:entries, [:transaction_id])
  end
end
