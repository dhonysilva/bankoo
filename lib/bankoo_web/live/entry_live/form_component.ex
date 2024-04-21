defmodule BankooWeb.EntryLive.FormComponent do
  use BankooWeb, :live_component

  alias Bankoo.Banks

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage entry records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="entry-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="number" label="User" />
        <.input
          field={@form[:type]}
          type="select"
          label="Type"
          prompt="Choose a value"
          options={Ecto.Enum.values(Bankoo.Banks.Entry, :type)}
        />
        <.input field={@form[:amount]} type="number" label="Amount" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Entry</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{entry: entry} = assigns, socket) do
    changeset = Banks.change_entry(entry)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"entry" => entry_params}, socket) do
    changeset =
      socket.assigns.entry
      |> Banks.change_entry(entry_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"entry" => entry_params}, socket) do
    save_entry(socket, socket.assigns.action, entry_params)
  end

  defp save_entry(socket, :edit, entry_params) do
    case Banks.update_entry(socket.assigns.entry, entry_params) do
      {:ok, entry} ->
        notify_parent({:saved, entry})

        {:noreply,
         socket
         |> put_flash(:info, "Entry updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_entry(socket, :new, entry_params) do
    case Banks.create_entry(entry_params) do
      {:ok, entry} ->
        notify_parent({:saved, entry})

        {:noreply,
         socket
         |> put_flash(:info, "Entry created successfully")
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
