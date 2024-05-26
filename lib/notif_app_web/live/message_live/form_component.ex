defmodule NotifAppWeb.MessageLive.FormComponent do
  use NotifAppWeb, :live_component

  alias NotifApp.{Users, Messages.Message, Messages, Contacts, Groups}

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Compose a new message.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="message-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:user_id]} type="hidden" value={@user_id}/>
        <.input
          :if={assigns.form.params["type"] != nil}
          field={@form[:subject]}
          type="text"
          label="Subject"
          />
        <.input
          field={@form[:type]}
          type="select"
          label="Message Type"
          value={assigns.form.params["type"]}
          options={[{"None", ""}, {"individual", "individual"}, {"group", "group"}]}
          />
        <.input
          :if={assigns.form.params["type"] == "individual"}
          field={@form[:recipients]}
          type="select"
          multiple
          label="Select Recipients"
          options={@contacts}
        />
        <.input
          :if={assigns.form.params["type"] == "group"}
          field={@form[:recipients]}
          type="select"
          label="Select Group"
          options={@groups}
        />
        <.input
          :if={assigns.form.params["type"] != nil}
          field={@form[:text]}
          type="text"
          label="Message" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{message: message} = assigns, socket) do
    changeset = Messages.change_message(message)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"message" => message_params}, socket) do
    changeset =
      socket.assigns.message
      |> Messages.change_message(message_params)
      |> Map.put(:action, :validate)

      {:noreply, assign_form(socket, changeset)}
    # recipients = Enum.to_list(message_params["recipients"])
    # IO.inspect(message_params)
    # params = message_params
    #   |> Map.update("recipients", [], fn update_recipients -> String.split(update_recipients, ",") end)
    # case message_params["type"] do
    #   "group" ->
    #     case message_params["recipients"] do
    #        nil ->
    #         changeset =
    #           socket.assigns.message
    #           |> Messages.change_message(message_params)
    #           |> Map.put(:action, :validate)

    #           {:noreply, assign_form(socket, changeset)}
    #       _ ->
    #         # get group
    #         # IO.inspect(message_params)
    #         group = Groups.get_group!(message_params["recipients"])
    #         params = message_params
    #         |> Map.put("recipients", group.contacts)
    #         IO.inspect(params["recipients"])
    #         changeset =
    #           socket.assigns.message
    #           |> Messages.change_message(params)
    #           |> Map.put(:action, :validate)

    #         {:noreply, assign_form(socket, changeset)}
    #     end
    #   "individual" ->
    #     # IO.inspect(message_params )
    #     changeset =
    #       socket.assigns.message
    #       |> Messages.change_message(message_params)
    #       |> Map.put(:action, :validate)

    #       {:noreply, assign_form(socket, changeset)}
    # end
      # |> Map.put(:action, :validate)

    # socket =
    #   socket |> assign(:msg_type, message_params["type"])

  end

  def handle_event("save", %{"message" => message_params}, socket) do
    IO.inspect(message_params)
    group = Groups.get_group!(message_params["recipients"])
    params = message_params
    |> Map.put("recipients", group.contacts)
    save_message(socket, socket.assigns.action, params)
  end

  defp save_message(socket, :edit, message_params) do
    case Messages.update_message(socket.assigns.message, message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_message(socket, :new, message_params) do
    # account_id = socket.assigns.current_account.id
    # user = Users.get_user_by_account_id(account_id)
    # contacts = Contacts.list_contacts(user.id)
    # groups = Groups.list_groups(user.id)

    # group_names =
    #   groups
    #   |> Enum.map(fn %{contacts: contacts, name: name} -> {contacts, name} end)

    # contact_options =
    #   contacts
    #   |> Enum.map(fn %{first_name: first_name, email_address: email_address} ->
    #     {first_name, email_address}
    #   end)

    case Messages.create_message(message_params) do
      {:ok, message} ->
        notify_parent({:saved, message})

        {:noreply,
         socket
         |> put_flash(:info, "Message created successfully")
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
