defmodule BankooWeb.CartItemController do
  use BankooWeb, :controller

  alias Bankoo.ShoppingCart

  def create(conn, %{"product_id" => product_id}) do
    case ShoppingCart.add_item_to_cart(conn.assigns.cart, product_id) do
      {:ok, _item} ->
        conn
        |> put_flash(:info, "Item adicionado ao Cart")
        |> redirect(to: ~p"/cart")

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Houve um erro ao adicionar esse item ao Cart")
        |> redirect(to: ~p"/cart")
    end
  end
end
