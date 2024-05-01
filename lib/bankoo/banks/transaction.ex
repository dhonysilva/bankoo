defmodule Bankoo.Banks.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bankoo.Banks.Entry

  schema "transactions" do

    belongs_to :user, Bankoo.Accounts.User

    has_many :entries, Entry

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs \\ %{}) do
    transaction
    |> cast(attrs, [:user_id])
    |> validate_required([:user_id])
  end
end
