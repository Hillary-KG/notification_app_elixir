defmodule NotifAppWeb.AccountRegistrationLive do
  use NotifAppWeb, :live_view

  alias NotifApp.{Accounts.Account, Accounts, Users}

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/accounts/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/accounts/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:first_name]} type="text" label="First Name" required />
        <.input field={@form[:last_name]} type="text" label="Last Name" required />
        <.input field={@form[:msisdn]} type="text" label="Phone Number" required />
        <%!-- <.input field={@form[:dob]} type="text" label="Date" required />
        <.input field={@form[:email]} type="text" label="First Name" required /> --%>
        <%!-- <.input field={@form[:email]} type="text" label="First Name" required /> --%>

        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_account_registration(%Account{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"account" => account_params}, socket) do
    case Accounts.register_account(account_params) do

      {:ok, account} ->
        IO.inspect(account_params)
        case Users.create_user(account, account_params) do
          {:ok, _user} ->
            {:ok, _} =
              # Accounts.deliver_account_confirmation_instructions(
              #   account,
              #   &url(~p"/accounts/confirm/#{&1}")
              #   )
                changeset = Accounts.change_account_registration(account)
                {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}
          {:error, %Ecto.Changeset{} = changeset} ->
                  {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
           end
      {:error, %Ecto.Changeset{} = changeset} ->
              {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}

    end
    # with {:ok, account} <- Accounts.register_account(account_params),
    #       {:ok, _user} <- Users.create_user(account, account_params)
    #       do

    #         else
    #           {:error, %Ecto.Changeset{} = changeset} ->
    #             {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    #       end
    # case Accounts.register_account(account_params) do
    #   {:ok, account} ->
    #     case Users.create_user(account, account_params) do
    #       {:ok, _user} ->
    #         IO.inspect(account)
    #         {:ok, _} =
    #           Accounts.deliver_account_confirmation_instructions(
    #             account,
    #             &url(~p"/accounts/confirm/#{&1}")
    #           )
    #         changeset = Accounts.change_account_registration(account)
    #         {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}
    #       {:error, %Ecto.Changeset{} = changeset} ->
    #           {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    #       end
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    # end
  end

  def handle_event("validate", %{"account" => account_params}, socket) do
    changeset = Accounts.change_account_registration(%Account{}, account_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "account")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
