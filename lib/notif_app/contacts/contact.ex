defmodule NotifApp.Contacts.Contact do
  alias NotifApp.{Users.User}
  use Ecto.Schema
  import Ecto.Changeset

  schema "contacts" do
    field :email_address, :string
    field :first_name, :string
    field :last_name, :string
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(contact, attrs) do
    contact
    |> cast(attrs, [:user_id, :email_address, :first_name, :last_name])
    |> validate_required([:user_id, :email_address, :first_name, :last_name])
    |> unique_constraint(:email_address)
  end
end
