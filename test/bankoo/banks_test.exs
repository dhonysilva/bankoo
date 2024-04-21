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

  describe "entries" do
    alias Bankoo.Banks.Entry

    import Bankoo.BanksFixtures

    @invalid_attrs %{type: nil, user_id: nil, amount: nil}

    test "list_entries/0 returns all entries" do
      entry = entry_fixture()
      assert Banks.list_entries() == [entry]
    end

    test "get_entry!/1 returns the entry with given id" do
      entry = entry_fixture()
      assert Banks.get_entry!(entry.id) == entry
    end

    test "create_entry/1 with valid data creates a entry" do
      valid_attrs = %{type: :credit, user_id: 42, amount: 42}

      assert {:ok, %Entry{} = entry} = Banks.create_entry(valid_attrs)
      assert entry.type == :credit
      assert entry.user_id == 42
      assert entry.amount == 42
    end

    test "create_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Banks.create_entry(@invalid_attrs)
    end

    test "update_entry/2 with valid data updates the entry" do
      entry = entry_fixture()
      update_attrs = %{type: :debit, user_id: 43, amount: 43}

      assert {:ok, %Entry{} = entry} = Banks.update_entry(entry, update_attrs)
      assert entry.type == :debit
      assert entry.user_id == 43
      assert entry.amount == 43
    end

    test "update_entry/2 with invalid data returns error changeset" do
      entry = entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Banks.update_entry(entry, @invalid_attrs)
      assert entry == Banks.get_entry!(entry.id)
    end

    test "delete_entry/1 deletes the entry" do
      entry = entry_fixture()
      assert {:ok, %Entry{}} = Banks.delete_entry(entry)
      assert_raise Ecto.NoResultsError, fn -> Banks.get_entry!(entry.id) end
    end

    test "change_entry/1 returns a entry changeset" do
      entry = entry_fixture()
      assert %Ecto.Changeset{} = Banks.change_entry(entry)
    end
  end
end
