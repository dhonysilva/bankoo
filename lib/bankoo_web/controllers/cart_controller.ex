defmodule BankooWeb.CartController do
  use BankooWeb, :controller

  alias Bankoo.ShoppingCart

  def show(conn, _params) do
    render(conn, :show, changeset: ShoppingCart.change_cart(conn.assigns.cart))
  end

  def update(conn, %{"cart" => cart_params}) do
    case ShoppingCart.update_cart(conn.assigns.cart, cart_params) do
      {:ok, _cart} ->
        redirect(conn, to: ~p"/cart")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Houve um error ao atualizar o Cart")
        |> redirect(to: ~p"/cart")
    end
  end
end
