defmodule NotifAppWeb.ContactLive.Index do
  alias NotifApp.Users
  use NotifAppWeb, :live_view

  alias NotifApp.Contacts
  alias NotifApp.Contacts.Contact

  @impl true
  def mount(_params, _session, socket) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)

    {:ok, stream(socket, :contacts, Contacts.list_contacts(user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Contact")
    |> assign(:contact, Contacts.get_contact!(id))
  end

  defp apply_action(socket, :new, _params) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    IO.inspect(user)
    socket
    |> assign(:user_id, user.id)
    |> assign(:page_title, "New Contact")
    |> assign(:contact, %Contact{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Contacts")
    |> assign(:contact, nil)
  end

  @impl true
  def handle_info({NotifAppWeb.ContactLive.FormComponent, {:saved, contact}}, socket) do
    {:noreply, stream_insert(socket, :contacts, contact)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    contact = Contacts.get_contact!(id)
    {:ok, _} = Contacts.delete_contact(contact)

    {:noreply, stream_delete(socket, :contacts, contact)}
  end
end
