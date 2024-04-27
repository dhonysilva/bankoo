defmodule BankooWeb.CartItemLiveTest do
  use BankooWeb.ConnCase

  import Phoenix.LiveViewTest
  import Bankoo.ShoppingCartFixtures

  @create_attrs %{price_when_carted: "120.5", quantity: 42}
  @update_attrs %{price_when_carted: "456.7", quantity: 43}
  @invalid_attrs %{price_when_carted: nil, quantity: nil}

  defp create_cart_item(_) do
    cart_item = cart_item_fixture()
    %{cart_item: cart_item}
  end

  describe "Index" do
    setup [:create_cart_item]

    test "lists all cart_items", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/cart_items")

      assert html =~ "Listing Cart items"
    end

    test "saves new cart_item", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/cart_items")

      assert index_live |> element("a", "New Cart item") |> render_click() =~
               "New Cart item"

      assert_patch(index_live, ~p"/cart_items/new")

      assert index_live
             |> form("#cart_item-form", cart_item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cart_item-form", cart_item: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cart_items")

      html = render(index_live)
      assert html =~ "Cart item created successfully"
    end

    test "updates cart_item in listing", %{conn: conn, cart_item: cart_item} do
      {:ok, index_live, _html} = live(conn, ~p"/cart_items")

      assert index_live |> element("#cart_items-#{cart_item.id} a", "Edit") |> render_click() =~
               "Edit Cart item"

      assert_patch(index_live, ~p"/cart_items/#{cart_item}/edit")

      assert index_live
             |> form("#cart_item-form", cart_item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#cart_item-form", cart_item: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/cart_items")

      html = render(index_live)
      assert html =~ "Cart item updated successfully"
    end

    test "deletes cart_item in listing", %{conn: conn, cart_item: cart_item} do
      {:ok, index_live, _html} = live(conn, ~p"/cart_items")

      assert index_live |> element("#cart_items-#{cart_item.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cart_items-#{cart_item.id}")
    end
  end

  describe "Show" do
    setup [:create_cart_item]

    test "displays cart_item", %{conn: conn, cart_item: cart_item} do
      {:ok, _show_live, html} = live(conn, ~p"/cart_items/#{cart_item}")

      assert html =~ "Show Cart item"
    end

    test "updates cart_item within modal", %{conn: conn, cart_item: cart_item} do
      {:ok, show_live, _html} = live(conn, ~p"/cart_items/#{cart_item}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cart item"

      assert_patch(show_live, ~p"/cart_items/#{cart_item}/show/edit")

      assert show_live
             |> form("#cart_item-form", cart_item: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#cart_item-form", cart_item: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/cart_items/#{cart_item}")

      html = render(show_live)
      assert html =~ "Cart item updated successfully"
    end
  end
end
