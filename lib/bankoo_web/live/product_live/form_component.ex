defmodule BankooWeb.ProductLive.FormComponent do
  use BankooWeb, :live_component

  alias Bankoo.Catalog
  alias Bankoo.Catalog.ProductCategories

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="product-form"
        multipart
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:price]} type="number" label="Price" step="any" />
        <.input field={@form[:views]} type="number" label="Views" />

        <h1 class="text-md font-semibold leading-8 text-zinc-800">
          Categories
        </h1>

        <div id="categories" class="space-y-2">
          <.inputs_for :let={b_category} field={@form[:product_categories]}>
            <div class="flex space-x-2 drag-item">
              <input type="hidden" name="product[categories_order][]" value={b_category.index} />

              <.input
                type="select"
                field={b_category[:category_id]}
                placeholder="Category"
                options={@categories}
              />

              <label class="cursor-pointer">
                <input
                  type="checkbox"
                  name="product[categories_delete][]"
                  value={b_category.index}
                  class="hidden"
                />
                <.icon name="hero-x-mark" class="w-6 h-6 relative top-2" />
              </label>
            </div>
          </.inputs_for>
        </div>
        <:actions>
          <label class="block cursor-pointer">
            <input type="checkbox" name="product[categories_order][]" class="hidden" />
            <.icon name="hero-plus-circle" /> add more
          </label>
        </:actions>

        <:actions>
          <.button phx-disable-with="Saving...">Save Product</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = Catalog.change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)
     |> assign_categories()}
  end

  defp assign_categories(socket) do
    categories =
      Catalog.list_categories()
      |> Enum.map(&{&1.title, &1.id})

    assign(socket, :categories, categories)
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    changeset =
      socket.assigns.product
      |> Catalog.change_product(product_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"product" => product_params}, socket) do
    save_product(socket, socket.assigns.action, product_params)
  end

  defp save_product(socket, :edit, product_params) do
    case Catalog.update_product(socket.assigns.product, product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_product(socket, :new, product_params) do
    case Catalog.create_product(product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        {:noreply,
         socket
         |> put_flash(:info, "Product created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    if Ecto.Changeset.get_field(changeset, :product_categories) == [] do
      product_category = %ProductCategories{}

      changeset = Ecto.Changeset.put_change(changeset, :product_categories, [product_category])
      assign(socket, :form, to_form(changeset))
    else
      assign(socket, :form, to_form(changeset))
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
