defmodule NotifAppWeb.UserDashboardLive.Index do
  alias NotifApp.Users
  alias NotifApp.Messages
  use NotifAppWeb, :live_view



  @impl true
  def mount(_params, _session, socket) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    # socket = socket
    # |> assign(:messages, Messages.list_messages(user.id))
    # {:ok, socket}
    {:ok, stream(socket, :messages, Messages.list_messages(user.id))}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit User dashboard")
  #   |> assign(:user_dashboard, UserDashboards.get_user_dashboard!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New User dashboard")
  #   |> assign(:user_dashboard, %UserDashboard{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing User dashboards")
  #   |> assign(:user_dashboard, nil)
  # end

  # @impl true
  # def handle_info({NotifAppWeb.UserDashboardLive.FormComponent, {:saved, user_dashboard}}, socket) do
  #   {:noreply, stream_insert(socket, :user_dashboards, user_dashboard)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   user_dashboard = UserDashboards.get_user_dashboard!(id)
  #   {:ok, _} = UserDashboards.delete_user_dashboard(user_dashboard)

  #   {:noreply, stream_delete(socket, :user_dashboards, user_dashboard)}
  # end
end
