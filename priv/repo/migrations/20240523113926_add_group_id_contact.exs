defmodule NotifApp.Repo.Migrations.AddGroupIdContact do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      remove :user_id, references(:users, on_delete: :nothing)
      add :group_id, references(:groups, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
