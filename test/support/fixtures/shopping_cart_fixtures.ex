defmodule Bankoo.ShoppingCartFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Bankoo.ShoppingCart` context.
  """

  @doc """
  Generate a cart.
  """
  def cart_fixture(attrs \\ %{}) do
    {:ok, cart} =
      attrs
      |> Enum.into(%{

      })
      |> Bankoo.ShoppingCart.create_cart()

    cart
  end

  @doc """
  Generate a cart_item.
  """
  def cart_item_fixture(attrs \\ %{}) do
    {:ok, cart_item} =
      attrs
      |> Enum.into(%{
        price_when_carted: "120.5",
        quantity: 42
      })
      |> Bankoo.ShoppingCart.create_cart_item()

    cart_item
  end
end
