defmodule NotifAppWeb.AdminLive.User do
    use NotifAppWeb, :live_view

    alias NotifApp.{Users, Accounts}

    @impl true
    def mount(_params, _session, socket) do
      {:ok, socket}
    end

    @impl true
    def handle_params(%{"id" => id}, _, socket) do
      user = Users.get_user_by_account_id(id)
      user_messages = user.messages
      {:noreply,
       socket
       |> assign(:page_title, page_title(socket.assigns.live_action))
       |> assign(:user, user)
       |> stream(:messages, user_messages)}
    end

    defp page_title(:user), do: "User"
    # defp page_title(:edit), do: "Edit Message"

    @impl true
    def handle_event("delete", %{"id" => id}, socket) do
      account = Accounts.get_account!(id)
      {:ok, _} =Accounts.delete_account(account)
      socket =
        socket
        |> put_flash(:info, "User deleted successfully")
        |> push_patch(to: ~p"/admin/users")

      {:noreply, socket}
    end
end
