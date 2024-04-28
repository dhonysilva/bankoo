defmodule BankooWeb.CartController do
  use BankooWeb, :controller

  alias Bankoo.ShoppingCart

  def show(conn, _params) do
    render(conn, :show, changeset: ShoppingCart.change_cart(conn.assigns.cart))
  end
end
