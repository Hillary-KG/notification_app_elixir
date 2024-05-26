defmodule NotifAppWeb.AdminLive.UserForm do
  use NotifAppWeb, :live_component

  alias NotifApp.Users

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <%!-- <:subtitle>Use this form to manage user records in your database.</:subtitle> --%>
      </.header>

      <.simple_form
        for={@form}
        id="user-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" label="First name" disabled/>
        <.input field={@form[:last_name]} type="text" label="Last name" disabled/>
        <.input field={@form[:msisdn]} type="text" label="Msisdn" disabled/>
        <%!-- <.input
          field={@form[:contacts]}
          type="select"
          multiple
          label="Contacts"
          options={[{"Option 1", "option1"}, {"Option 2", "option2"}]}
        /> --%>
        <%!-- <.input field={@form[:dob]} type="date" label="Dob" />
        <.input field={@form[:bio]} type="text" label="Bio" /> --%>
        <.input
          field={@form[:plan]}
          type="select"
          label="Plan"
          value={@user.plan}
          options={[{"Silver", "silver"}, {"Gold", "gold"}]}
        />

        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          value="Active"
          options = {[{"Activate", "active"}, {"Deactivate", "inactive"}]}
          disabled
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save User</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user: user} = assigns, socket) do
    changeset = Users.change_user(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      socket.assigns.user
      |> Users.change_user(user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    IO.inspect(socket.assigns.action)
    save_user(socket, socket.assigns.action, user_params)
  end

  defp save_user(socket, :update_user, user_params) do
    case Users.update_user(socket.assigns.user, user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User's plan updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_user(socket, :new, user_params) do
    case Users.create_user(user_params) do
      {:ok, user} ->
        notify_parent({:saved, user})

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
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
