defmodule NotifApp.Repo.Migrations.AddMessageSubject do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :subject, :string
    end
  end
end
