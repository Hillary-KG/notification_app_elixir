defmodule NotifApp.Repo.Migrations.ChangeGroupContactReffs do
  use Ecto.Migration

  def change do
    alter table(:contacts) do
      remove :group_id
    end

    alter table(:groups) do
      add :contacts, {:array, :string}
    end
  end
end
