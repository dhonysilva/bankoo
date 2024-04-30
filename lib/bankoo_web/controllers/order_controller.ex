defmodule BankooWeb.OrderController do
  use BankooWeb, :controller

  alias Bankoo.Orders

  def create(conn, _) do
    case Orders.complete_order(conn.assigns.cart) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created successfully.")
        |> redirect(to: ~p"/orders/#{order}")

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Houve um error processando a Order")
        |> redirect(to: ~p"/cart")
    end
  end

  def index(conn, _) do
    orders = Orders.list_orders()
    render(conn, :index, orders: orders)
  end

  def show(conn, %{"id" => id}) do
    user = conn.assigns[:current_user]

    order = Orders.get_order!(user, id)
    render(conn, :show, order: order)
  end
end
