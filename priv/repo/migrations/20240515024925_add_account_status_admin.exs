defmodule NotifApp.Repo.Migrations.AddAccountStatusAdmin do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :is_admin, :boolean, default: false
      add :is_superuser, :boolean, default: false
      add :status, :string, default: "active"
    end
  end
end
