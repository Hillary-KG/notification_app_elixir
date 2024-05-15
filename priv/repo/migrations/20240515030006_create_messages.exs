defmodule NotifApp.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :recipients, {:array, :string}
      add :text, :text
      add :type, :string
      add :status, :string
      add :sender_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:sender_id])
  end
end
