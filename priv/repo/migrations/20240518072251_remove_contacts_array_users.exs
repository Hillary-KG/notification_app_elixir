defmodule NotifApp.Repo.Migrations.RemoveContactsArrayUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      remove :contacts
    end
  end
end
