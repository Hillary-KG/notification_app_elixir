defmodule NotifApp.Repo.Migrations.ChangeUserIdMessages do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      remove :sender_id
      add :user_id, references(:users, on_delete: :delete_all)
    end

    # drop index(:messages, [:sender_id])
    create index(:messages, [:user_id])
  end
end
