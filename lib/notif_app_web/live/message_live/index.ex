defmodule NotifAppWeb.MessageLive.Index do
  use NotifAppWeb, :live_view
  alias NotifApp.Users

  alias NotifApp.Messages
  alias NotifApp.Messages.Message

  @impl true
  def mount(_params, _session, socket) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    IO.inspect(user)
    {:ok, stream(socket, :messages, Messages.list_messages(user.id))}
  end

  # @impl true
  # def handle_params(params, _url, socket) do
  #   {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  # end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Message")
  #   |> assign(:message, Messages.get_message!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Message")
  #   |> assign(:message, %Message{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Messages")
  #   |> assign(:message, nil)
  # end

  # @impl true
  # def handle_info({NotifAppWeb.MessageLive.FormComponent, {:saved, message}}, socket) do
  #   {:noreply, stream_insert(socket, :messages, message)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   message = Messages.get_message!(id)
  #   {:ok, _} = Messages.delete_message(message)

  #   {:noreply, stream_delete(socket, :messages, message)}
  # end
end
