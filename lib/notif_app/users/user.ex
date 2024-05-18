defmodule NotifApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :bio, :string
    # field :contacts, {:array, :string}
    field :dob, :date
    field :first_name, :string
    field :last_name, :string
    field :msisdn, :string
    field :plan, :string, default: "silver"
    field :status, :string, default: "active"
    belongs_to :account, NotifApp.Accounts.Account
    has_many :messages, NotifApp.Messages.Message
    has_many :contacts, NotifApp.Contacts.Contact

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:account_id, :first_name, :last_name, :msisdn, :dob, :bio, :plan, :status])
    |> validate_required([:account_id, :first_name, :last_name, :msisdn, :plan, :status])
    |> unique_constraint(:msisdn)
  end
end
