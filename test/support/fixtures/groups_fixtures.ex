defmodule NotifApp.GroupsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotifApp.Groups` context.
  """

  @doc """
  Generate a group.
  """
  def group_fixture(attrs \\ %{}) do
    {:ok, group} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status"
      })
      |> NotifApp.Groups.create_group()

    group
  end
end
