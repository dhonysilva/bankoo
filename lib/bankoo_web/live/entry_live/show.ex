defmodule BankooWeb.EntryLive.Show do
  use BankooWeb, :live_view

  alias Bankoo.Banks

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:entry, Banks.get_entry!(id))}
  end

  defp page_title(:show), do: "Show Entry"
  defp page_title(:edit), do: "Edit Entry"
end
