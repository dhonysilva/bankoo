defmodule Bankoo.Banks.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do

    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [])
    |> validate_required([])
  end
end
