defmodule NotifApp.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias NotifApp.Accounts.Account
  alias NotifApp.Accounts
  alias NotifApp.Repo

  alias NotifApp.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id) |> Repo.preload(:account) |> Repo.preload(:messages) |> Repo.preload(:contacts)


  def get_user_by_account_id(account_id) do
    User
    |> where(account_id: ^account_id)
    |> Repo.one()
    |> Repo.preload(:account)
    |> Repo.preload(:messages)
    |> Repo.preload(:contacts)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(account, attrs \\ %{}) do
    # %User{}
    IO.puts("creating user !!!!!!!!!!!!!!!!!!!!!!!")
    # IO.inspect(account)
    account
    |> Ecto.build_assoc(:user)
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    acccount =
      Accounts.get_account!(user.account)
      |> Account.update_changeset(%{"status" => "inactive"})
      |> Repo.update()

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user, attrs \\ {}) do
    # Repo.delete(user)
    IO.inspect(user.account)
    user.account
      |> Accounts.update_account(attrs)

    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
