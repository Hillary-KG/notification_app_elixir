defmodule NotifAppWeb.MessageLive.New do
  alias NotifApp.Contacts
  alias NotifApp.Users
  alias NotifApp.Mailer
  alias MyApp.Email
  alias NotifApp.Messages
  use NotifAppWeb, :live_view

  def mount(_params, _session, socket) do
    changeset = Messages.Message.changeset(%Messages.Message{})
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    contacts = Contacts.list_contacts(user.id)
    contact_options =
      contacts
      |> Enum.map(fn %{first_name: first_name, email_address: email_address} -> {first_name, email_address} end)

    IO.inspect(contact_options)
    socket =
      socket
      |> assign(:contacts, contact_options)
      |> assign(
        :form,
        to_form(changeset)
      )
      {:ok, socket}
  end

  def handle_event("submit", %{"message" => message_params}, socket) do
    account_id = socket.assigns.current_account.id
    user = Users.get_user_by_account_id(account_id)
    IO.inspect(user.id)
    params = message_params
    |> Map.put("user_id", user.id)
    |> Map.put("type", "single")
    |> Map.put("recipients", message_params["recipients"])


    IO.inspect(params)
    # :user_id, :recipients, :subject, :text, :type, :status
    case Messages.create_message(params) do
       {:ok, _msg} ->
        case Email.build_email(message_params["subject"], message_params["recipients"], message_params["text"])
          |> Mailer.deliver_later() do
            {:ok, _email} ->
                socket
                |> put_flash(:info, "message sent")
                |> push_navigate(to: ~p"/home")
                {:noreply, socket}
              {:error, error} ->
                socket
                |> put_flash(:error, to_string(error))
                |> push_navigate(to: ~p"/home")
              {:noreply, socket}
          end
        {:error, changeset} ->
          IO.inspect(changeset)
          socket
          |> assign(
            :form,
            to_form(changeset)
          )
          {:noreply, socket}
    end
  end


end
