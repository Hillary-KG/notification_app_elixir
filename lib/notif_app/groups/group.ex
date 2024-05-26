defmodule NotifApp.Groups.Group do
  alias NotifApp.{Users.User, Contacts.Contact}

  use Ecto.Schema
  import Ecto.Changeset

  schema "groups" do
    field :name, :string
    field :status, :string, default: "active"
    field :contacts, {:array, :string}
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(group, attrs) do
    group
    |> cast(attrs, [:user_id, :name, :contacts, :status])
    |> validate_required([:user_id, :name, :status])
  end
end
