defmodule NotifApp.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotifApp.Contacts` context.
  """

  @doc """
  Generate a unique contact email_address.
  """
  def unique_contact_email_address, do: "some email_address#{System.unique_integer([:positive])}"

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        email_address: unique_contact_email_address(),
        first_name: "some first_name",
        last_name: "some last_name"
      })
      |> NotifApp.Contacts.create_contact()

    contact
  end
end
