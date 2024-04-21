defmodule Bankoo.BanksTest do
  use Bankoo.DataCase

  alias Bankoo.Banks

  describe "transactions" do
    alias Bankoo.Banks.Transaction

    import Bankoo.BanksFixtures

    @invalid_attrs %{}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Banks.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Banks.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{}

      assert {:ok, %Transaction{} = transaction} = Banks.create_transaction(valid_attrs)
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Banks.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{}

      assert {:ok, %Transaction{} = transaction} = Banks.update_transaction(transaction, update_attrs)
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Banks.update_transaction(transaction, @invalid_attrs)
      assert transaction == Banks.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Banks.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Banks.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Banks.change_transaction(transaction)
    end
  end
end
