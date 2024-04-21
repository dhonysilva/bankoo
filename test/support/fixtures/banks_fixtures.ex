defmodule Bankoo.BanksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankoo.Banks` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{

      })
      |> Bankoo.Banks.create_transaction()

    transaction
  end

  @doc """
  Generate a entry.
  """
  def entry_fixture(attrs \\ %{}) do
    {:ok, entry} =
      attrs
      |> Enum.into(%{
        amount: 42,
        type: :credit,
        user_id: 42
      })
      |> Bankoo.Banks.create_entry()

    entry
  end
end
