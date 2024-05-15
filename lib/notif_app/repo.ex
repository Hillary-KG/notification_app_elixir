defmodule NotifApp.Repo do
  use Ecto.Repo,
    otp_app: :notif_app,
    adapter: Ecto.Adapters.Postgres
end
