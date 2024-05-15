defmodule NotifApp.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotifApp.Users` context.
  """

  @doc """
  Generate a unique user msisdn.
  """
  def unique_user_msisdn, do: "some msisdn#{System.unique_integer([:positive])}"

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        bio: "some bio",
        contacts: ["option1", "option2"],
        dob: ~D[2024-05-14],
        first_name: "some first_name",
        last_name: "some last_name",
        msisdn: unique_user_msisdn(),
        plan: "some plan",
        status: "some status"
      })
      |> NotifApp.Users.create_user()

    user
  end
end
