defmodule NotifApp.UsersTest do
  use NotifApp.DataCase

  alias NotifApp.Users

  describe "users" do
    alias NotifApp.Users.User

    import NotifApp.UsersFixtures

    @invalid_attrs %{bio: nil, contacts: nil, dob: nil, first_name: nil, last_name: nil, msisdn: nil, plan: nil, status: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Users.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Users.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{bio: "some bio", contacts: ["option1", "option2"], dob: ~D[2024-05-14], first_name: "some first_name", last_name: "some last_name", msisdn: "some msisdn", plan: "some plan", status: "some status"}

      assert {:ok, %User{} = user} = Users.create_user(valid_attrs)
      assert user.bio == "some bio"
      assert user.contacts == ["option1", "option2"]
      assert user.dob == ~D[2024-05-14]
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.msisdn == "some msisdn"
      assert user.plan == "some plan"
      assert user.status == "some status"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Users.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{bio: "some updated bio", contacts: ["option1"], dob: ~D[2024-05-15], first_name: "some updated first_name", last_name: "some updated last_name", msisdn: "some updated msisdn", plan: "some updated plan", status: "some updated status"}

      assert {:ok, %User{} = user} = Users.update_user(user, update_attrs)
      assert user.bio == "some updated bio"
      assert user.contacts == ["option1"]
      assert user.dob == ~D[2024-05-15]
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.msisdn == "some updated msisdn"
      assert user.plan == "some updated plan"
      assert user.status == "some updated status"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Users.update_user(user, @invalid_attrs)
      assert user == Users.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Users.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Users.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Users.change_user(user)
    end
  end
end
