defmodule NotifApp.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :recipients, {:array, :string}
    field :subject, :string
    field :text, :string
    field :status, :string, default: "queued"
    field :type, :string
    belongs_to :user, NotifApp.Users.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs \\ %{}) do
    message
    |> cast(attrs, [:user_id, :recipients, :subject, :text, :type, :status])
    |> validate_required([:user_id, :recipients, :subject, :text, :type, :status])
  end
end
