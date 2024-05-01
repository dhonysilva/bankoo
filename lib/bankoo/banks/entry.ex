defmodule Bankoo.Banks.Entry do
  use Ecto.Schema
  import Ecto.Changeset

  schema "entries" do
    field :type, Ecto.Enum, values: [:credit, :debit]
    field :user_id, :integer
    field :amount, :integer

    belongs_to :transaction, Bankoo.Banks.Transaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(entry, attrs) do
    entry
    |> cast(attrs, [:user_id, :type, :amount])
    |> validate_required([:user_id, :type, :amount])
  end

  def new(transaction) do
    %__MODULE__{}
    |> change()
    |> put_assoc(:transaction, transaction)
  end
end
