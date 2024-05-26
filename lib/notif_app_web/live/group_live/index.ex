defmodule NotifAppWeb.GroupLive.Index do
  use NotifAppWeb, :live_view

  alias NotifApp.Groups
  alias NotifApp.{Groups.Group, Groups, Users, Contacts}

  @impl true
  def mount(_params, _session, socket) do
    account = socket.assigns.current_account
    user = Users.get_user_by_account_id(account.id)
    {:ok, stream(socket, :groups, Groups.list_groups(user.id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    contacts =
      Contacts.list_contacts(user.id)
      |> Enum.map(fn %{first_name: first_name, email_address: email_address} -> {first_name, email_address} end)
    socket
    |> assign(:contacts, contacts)
    |> assign(:user_id, user.id)
    |> assign(:page_title, "Edit Group")
    |> assign(:group, Groups.get_group!(id))
  end

  defp apply_action(socket, :new, _params) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    contacts =
      Contacts.list_contacts(user.id)
      |> Enum.map(fn %{first_name: first_name, email_address: email_address} -> {first_name, email_address} end)
    socket
    |> assign(:contacts, contacts)
    |> assign(:user_id, user.id)
    |> assign(:page_title, "New Group")
    |> assign(:group, %Group{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Groups")
    |> assign(:group, nil)
  end

  @impl true
  def handle_info({NotifAppWeb.GroupLive.FormComponent, {:saved, group}}, socket) do
    {:noreply, stream_insert(socket, :groups, group)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    group = Groups.get_group!(id)
    {:ok, _} = Groups.delete_group(group)

    {:noreply, stream_delete(socket, :groups, group)}
  end
end
