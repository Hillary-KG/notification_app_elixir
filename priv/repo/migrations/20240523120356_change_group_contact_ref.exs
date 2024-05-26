defmodule NotifApp.Repo.Migrations.ChangeGroupContactRef do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      remove :group_id
      add :group_id, references(:groups, on_delete: :nothing)
    end
  end
end
