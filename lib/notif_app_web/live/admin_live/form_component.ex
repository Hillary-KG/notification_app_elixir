defmodule NotifAppWeb.AdminLive.FormComponent do
  alias NotifApp.Accounts
  use NotifAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header class="text-center">
            <%= @title %>
            <:subtitle>Manage User Account</:subtitle>
          </.header>
          <div class="space-y-12 divide-y">
            <div>
              <.simple_form
                for={@form}
                id="update_user_form"
                phx-target={@myself}
                phx-submit="save"
                phx-change="validate"
              >
                <.input field={@form[:email]} type="email" label="Email" disabled/>
                <.input
                  field={@form[:is_admin]}
                  type="select" label="User Role"
                  options={[{"admin", true}, {"user", false}]}
                  value={@account.is_admin}
                  required
                />
                <%!-- <.input
                  field={@form[:plan]}
                  type="select" label="Plan"
                  options={[{"silver", "silver"}, {"gold", "gold"}]}
                  value={@account.user.plan}
                  required
                /> --%>
                <:actions>
                  <.button phx-disable-with="Updating...">Update</.button>
                </:actions>
              </.simple_form>
            </div>
          </div>
    </div>

    """
  end

  # def mount(%{"token" => token}, _session, socket) do
  #   socket =
  #     case Accounts.update_account_role(socket.assigns.current_account, token) do
  #       :ok ->
  #         put_flash(socket, :info, "Role changed successfully.")

  #       :error ->
  #         put_flash(socket, :error, "Role change failed")
  #     end

  #   {:ok, push_navigate(socket, to: ~p"/admin/uses")}
  # end

  # def mount(_params, _session, socket) do
  #   account = socket.assigns.current_account
  #   role_changeset = Accounts.change_account(account)
  #   current_role = if account.is_admin, do: "admin", else: "user"
  #   socket =
  #     socket
  #     |> assign(:current_role, current_role)
  #     |> assign(:current_email, account.email)
  #     |> assign(:role_form, to_form(role_changeset))
  #     |> assign(:trigger_submit, false)

  #   {:ok, socket}
  # end
  @impl true
  def update(%{account: account} = assigns, socket) do
    # changeset = Admins.change_admin(admin)
    IO.inspect(assigns)
    changeset = Accounts.change_account(account)
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"account" => account_params}, socket) do
    # %{"current_role" => role, "account" => account_params} = params
    changeset  =
      socket.assigns.account
      |> Accounts.change_account(account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", params, socket) do
    IO.inspect(params)
    %{"account"=> account_params } = params
    account = socket.assigns.account

    case Accounts.update_account(account, account_params) do
      {:ok, account} ->
        notify_parent({:saved, account})
        # user_update_form =
        #   account
        #   |> Accounts.change_account(account_params)
        #   |> to_form()

          {:noreply,
          socket
          |> assign(:trigger_submit, true)
          # |> assign(:update_form, user_update_form)
          |> put_flash(:info, "Account updated successfully")
          |> push_navigate(to: socket.assigns.navigate  )}

          # assign(socket, trigger_submit: true, role_form: user_update_form)}
      {:error, changeset} ->
            {:noreply, assign(socket, role_form: to_form(changeset))}
    end
  end

  # @impl true
  # def handle_event("validate", %{"admin" => admin_params}, socket) do
  #   changeset =
  #     socket.assigns.admin
  #     |> Admins.change_admin(admin_params)
  #     |> Map.put(:action, :validate)

  #   {:noreply, assign_form(socket, changeset)}
  # end

  # def handle_event("save", %{"admin" => admin_params}, socket) do
  #   save_admin(socket, socket.assigns.action, admin_params)
  # end

  # defp save_admin(socket, :edit, admin_params) do
  #   case Admins.update_admin(socket.assigns.admin, admin_params) do
  #     {:ok, admin} ->
  #       notify_parent({:saved, admin})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Admin updated successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  # defp save_admin(socket, :new, admin_params) do
  #   case Admins.create_admin(admin_params) do
  #     {:ok, admin} ->
  #       notify_parent({:saved, admin})

  #       {:noreply,
  #        socket
  #        |> put_flash(:info, "Admin created successfully")
  #        |> push_patch(to: socket.assigns.patch)}

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       {:noreply, assign_form(socket, changeset)}
  #   end
  # end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
