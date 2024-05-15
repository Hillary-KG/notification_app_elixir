defmodule NotifApp.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :recipients, {:array, :string}
    field :status, :string
    field :text, :string
    field :type, :string
    belongs_to :user, NotifApp.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:user_id, :recipients, :text, :type, :status])
    |> validate_required([:user_id, :recipients, :text, :type, :status])
  end
end
