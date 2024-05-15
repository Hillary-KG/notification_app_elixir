defmodule NotifApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :msisdn, :string
      add :contacts, {:array, :string}
      add :dob, :date
      add :bio, :text
      add :plan, :string
      add :status, :string
      add :account_id, references(:accounts, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:msisdn])
    create index(:users, [:account_id,  :msisdn])
  end
end
