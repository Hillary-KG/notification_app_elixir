defmodule NotifAppWeb.Router do
  use NotifAppWeb, :router

  import NotifAppWeb.AccountAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NotifAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_account
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # pipeline :admin do

  # end

  scope "/", NotifAppWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", NotifAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:notif_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NotifAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", NotifAppWeb do
    pipe_through [:browser, :redirect_if_account_is_authenticated]

    live_session :redirect_if_account_is_authenticated,
      on_mount: [{NotifAppWeb.AccountAuth, :redirect_if_account_is_authenticated}] do
      live "/accounts/register", AccountRegistrationLive, :new
      live "/accounts/log_in", AccountLoginLive, :new
      live "/accounts/reset_password", AccountForgotPasswordLive, :new
      live "/accounts/reset_password/:token", AccountResetPasswordLive, :edit
    end

    post "/accounts/log_in", AccountSessionController, :create
  end

  scope "/", NotifAppWeb do
    pipe_through [:browser, :require_authenticated_account]

    live_session :require_authenticated_account,
      on_mount: [{NotifAppWeb.AccountAuth, :ensure_authenticated}] do
      live "/accounts/settings", AccountSettingsLive, :edit
      live "/accounts/settings/confirm_email/:token", AccountSettingsLive, :confirm_email

      #messages
      live "/home",  UserLive.Index, :index
      live "/messages/new", MessageLive.Index, :new
      live "/messages/:id", MessageLive.Show, :show

      # contacts route
      live "/contacts", ContactLive.Index, :index
      live "/contacts/new", ContactLive.Index, :new
      live "/contacts/:id/edit", ContactLive.Index, :edit
      live "/contacts/delete", ContactLive.Index, :delete

      # group routes
      live "/groups", GroupLive.Index, :index
      live "/groups/new", GroupLive.Index, :new
      live "/groups/edit/:id", GroupLive.Index, :edit
      live "/groups/delete/:id", GroupLive.Index, :delete

    end
  end

  scope "/admin", NotifAppWeb do
    pipe_through [:browser, :require_admin_user, :require_superuser]

    live_session :require_admin_user,
      on_mount: [{NotifAppWeb.AccountAuth, :ensure_admin}] do
      live "/home", AdminLive.Index
      live "/users", AdminLive.Index, :index
      live "/users/:id/update_account", AdminLive.Index, :update_account
      live "/users/:id/update_user", AdminLive.Index, :update_user
      live "/users/:id", AdminLive.User, :user
      end
    live_session :require_superuser,
      on_mount: [{NotifAppWeb.AccountAuth, :ensure_superuser}] do
      live "/admins", UserLive.Admins
      end

  end

  scope "/", NotifAppWeb do
    pipe_through [:browser]

    delete "/accounts/log_out", AccountSessionController, :delete

    live_session :current_account,
      on_mount: [{NotifAppWeb.AccountAuth, :mount_current_account}] do
      live "/accounts/confirm/:token", AccountConfirmationLive, :edit
      live "/accounts/confirm", AccountConfirmationInstructionsLive, :new
    end
  end
end
