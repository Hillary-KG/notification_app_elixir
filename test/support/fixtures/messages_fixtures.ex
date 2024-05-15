defmodule NotifApp.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `NotifApp.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        recipients: ["option1", "option2"],
        status: "some status",
        text: "some text",
        type: "some type"
      })
      |> NotifApp.Messages.create_message()

    message
  end
end
