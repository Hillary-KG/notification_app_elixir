defmodule NotifApp.MessagesTest do
  use NotifApp.DataCase

  alias NotifApp.Messages

  describe "messages" do
    alias NotifApp.Messages.Message

    import NotifApp.MessagesFixtures

    @invalid_attrs %{recipients: nil, status: nil, text: nil, type: nil}

    test "list_messages/0 returns all messages" do
      message = message_fixture()
      assert Messages.list_messages() == [message]
    end

    test "get_message!/1 returns the message with given id" do
      message = message_fixture()
      assert Messages.get_message!(message.id) == message
    end

    test "create_message/1 with valid data creates a message" do
      valid_attrs = %{recipients: ["option1", "option2"], status: "some status", text: "some text", type: "some type"}

      assert {:ok, %Message{} = message} = Messages.create_message(valid_attrs)
      assert message.recipients == ["option1", "option2"]
      assert message.status == "some status"
      assert message.text == "some text"
      assert message.type == "some type"
    end

    test "create_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Messages.create_message(@invalid_attrs)
    end

    test "update_message/2 with valid data updates the message" do
      message = message_fixture()
      update_attrs = %{recipients: ["option1"], status: "some updated status", text: "some updated text", type: "some updated type"}

      assert {:ok, %Message{} = message} = Messages.update_message(message, update_attrs)
      assert message.recipients == ["option1"]
      assert message.status == "some updated status"
      assert message.text == "some updated text"
      assert message.type == "some updated type"
    end

    test "update_message/2 with invalid data returns error changeset" do
      message = message_fixture()
      assert {:error, %Ecto.Changeset{}} = Messages.update_message(message, @invalid_attrs)
      assert message == Messages.get_message!(message.id)
    end

    test "delete_message/1 deletes the message" do
      message = message_fixture()
      assert {:ok, %Message{}} = Messages.delete_message(message)
      assert_raise Ecto.NoResultsError, fn -> Messages.get_message!(message.id) end
    end

    test "change_message/1 returns a message changeset" do
      message = message_fixture()
      assert %Ecto.Changeset{} = Messages.change_message(message)
    end
  end
end
