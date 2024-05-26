defmodule NotifAppWeb.UserLive.Index do
  use NotifAppWeb, :live_view
  alias NotifApp.{Users, Messages, Contacts, Groups}

  @impl true
  def mount(_params, _session, socket) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    messages = Messages.list_messages(user.id)
    contacts = Contacts.list_contacts(user.id)
    groups = Groups.list_groups(user.id)

    {:ok,
      socket
      |> stream(:messages, messages)
      |> stream(:contacts, contacts)
      |> stream(:groups, groups)
    }
    # {:ok, stream(socket, :users, Users.list_users())}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit User")
  #   |> assign(:user, Users.get_user!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New User")
  #   |> assign(:user, %User{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Users")
  #   |> assign(:user, nil)
  # end

  # @impl true
  # def handle_info({NotifAppWeb.UserLive.FormComponent, {:saved, user}}, socket) do
  #   {:noreply, stream_insert(socket, :users, user)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   user = Users.get_user!(id)
  #   {:ok, _} = Users.delete_user(user)

  #   {:noreply, stream_delete(socket, :users, user)}
  # end
  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Messages.get_message!(id)
    {:ok, _} = Messages.delete_message(message)

    {:noreply, stream_delete(socket, :messages, message)}
  end
end
