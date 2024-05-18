defmodule NotifAppWeb.UserLive.Admins do
  alias NotifApp.Accounts
  use NotifAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users, Accounts.list_admins())}
  end
end
