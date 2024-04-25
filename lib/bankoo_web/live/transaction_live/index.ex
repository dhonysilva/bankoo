defmodule BankooWeb.TransactionLive.Index do
  use BankooWeb, :live_view

  alias Bankoo.Banks

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    changeset = Banks.Transaction.changeset(%Banks.Transaction{})

    socket =
      socket
      |> assign(:transactions, Banks.list_transactions(user_id))
      |> assign(
        :form,
        to_form(changeset)
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"transaction" => transaction_params}, socket) do
    params =
      transaction_params
      |> Map.put("user_id", socket.assigns.current_user.id)

    case Banks.create_transaction(params) do
      {:ok, transaction} ->
        socket =
          socket
          |> assign(:transactions, [transaction | socket.assigns.transactions])

        {:noreply, socket}

      {:error, changeset} ->
        socket =
          socket
          |> assign(
            :form,
            to_form(changeset)
          )

        {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Banks.get_transaction!(id)
    {:ok, _} = Banks.delete_transaction(transaction)

    socket =
      socket
      |> assign(:transactions, Banks.list_transactions())

    {:noreply, socket}
  end

end
