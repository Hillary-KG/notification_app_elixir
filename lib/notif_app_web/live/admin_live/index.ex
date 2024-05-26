defmodule NotifAppWeb.AdminLive.Index do

  alias NotifApp.{Accounts, Users, Users.User}

  use NotifAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :update_account, %{"id" => id}) do
    IO.inspect("UID #{id}")
    socket
    |> assign(:page_title, "Update Account")
    |> assign(:account, Accounts.get_account!(id))
  end

  defp apply_action(socket, :update_user, %{"id" => id}) do
    IO.inspect("Plan UID #{id}")
    socket
    |> assign(:page_title, "Update User")
    |> assign(:user, Users.get_user_by_account_id(id))
  end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Admin")
  #   |> assign(:admin, %Admin{})
  # end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users")
  end

  # @impl true
  # def handle_info({NotifAppWeb.AdminLive.FormComponent, {:saved, admin}}, socket) do
  #   {:noreply, stream_insert(socket, :admins, admin)}
  # end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    account = Accounts.get_account!(id)
    {:ok, _} =Accounts.delete_account(account)

    {:noreply, stream_delete(socket, :users, account)}
  end
  @impl true
  def handle_event("deactivate", %{"id" => id}, socket) do
    user = Users.get_user!(id)
    {:ok, _} = Users.delete_user(user, %{"status" => "inactive"})

    {:noreply, stream_delete(socket, :users, user)}
  end

  @impl true
  def handle_event("activate", %{"id" => id}, socket) do
    user = Users.get_user!(id)
    {:ok, _} = Users.delete_user(user, %{"status" => "active"})

    {:noreply, stream_delete(socket, :users, user)}
  end
end
