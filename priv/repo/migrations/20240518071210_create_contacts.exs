defmodule NotifApp.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add :email_address, :string
      add :first_name, :string
      add :last_name, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:contacts, [:user_id, :email_address])
    create index(:contacts, [:user_id, :email_address, :first_name, :last_name])
  end
end
