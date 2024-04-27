defmodule BankooWeb.CartItemLive.FormComponent do
  use BankooWeb, :live_component

  alias Bankoo.ShoppingCart

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage cart_item records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="cart_item-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:price_when_carted]} type="number" label="Price when carted" step="any" />
        <.input field={@form[:quantity]} type="number" label="Quantity" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Cart item</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{cart_item: cart_item} = assigns, socket) do
    changeset = ShoppingCart.change_cart_item(cart_item)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"cart_item" => cart_item_params}, socket) do
    changeset =
      socket.assigns.cart_item
      |> ShoppingCart.change_cart_item(cart_item_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"cart_item" => cart_item_params}, socket) do
    save_cart_item(socket, socket.assigns.action, cart_item_params)
  end

  defp save_cart_item(socket, :edit, cart_item_params) do
    case ShoppingCart.update_cart_item(socket.assigns.cart_item, cart_item_params) do
      {:ok, cart_item} ->
        notify_parent({:saved, cart_item})

        {:noreply,
         socket
         |> put_flash(:info, "Cart item updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_cart_item(socket, :new, cart_item_params) do
    case ShoppingCart.create_cart_item(cart_item_params) do
      {:ok, cart_item} ->
        notify_parent({:saved, cart_item})

        {:noreply,
         socket
         |> put_flash(:info, "Cart item created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
