defmodule NotifApp.TestConsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotifApp.TestCons` context.
  """

  @doc """
  Generate a test_con.
  """
  def test_con_fixture(attrs \\ %{}) do
    {:ok, test_con} =
      attrs
      |> Enum.into(%{
        desc: "some desc",
        name: "some name"
      })
      |> NotifApp.TestCons.create_test_con()

    test_con
  end
end
