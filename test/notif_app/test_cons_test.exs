defmodule NotifApp.TestConsTest do
  use NotifApp.DataCase

  alias NotifApp.TestCons

  describe "test_cons" do
    alias NotifApp.TestCons.TestCon

    import NotifApp.TestConsFixtures

    @invalid_attrs %{desc: nil, name: nil}

    test "list_test_cons/0 returns all test_cons" do
      test_con = test_con_fixture()
      assert TestCons.list_test_cons() == [test_con]
    end

    test "get_test_con!/1 returns the test_con with given id" do
      test_con = test_con_fixture()
      assert TestCons.get_test_con!(test_con.id) == test_con
    end

    test "create_test_con/1 with valid data creates a test_con" do
      valid_attrs = %{desc: "some desc", name: "some name"}

      assert {:ok, %TestCon{} = test_con} = TestCons.create_test_con(valid_attrs)
      assert test_con.desc == "some desc"
      assert test_con.name == "some name"
    end

    test "create_test_con/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = TestCons.create_test_con(@invalid_attrs)
    end

    test "update_test_con/2 with valid data updates the test_con" do
      test_con = test_con_fixture()
      update_attrs = %{desc: "some updated desc", name: "some updated name"}

      assert {:ok, %TestCon{} = test_con} = TestCons.update_test_con(test_con, update_attrs)
      assert test_con.desc == "some updated desc"
      assert test_con.name == "some updated name"
    end

    test "update_test_con/2 with invalid data returns error changeset" do
      test_con = test_con_fixture()
      assert {:error, %Ecto.Changeset{}} = TestCons.update_test_con(test_con, @invalid_attrs)
      assert test_con == TestCons.get_test_con!(test_con.id)
    end

    test "delete_test_con/1 deletes the test_con" do
      test_con = test_con_fixture()
      assert {:ok, %TestCon{}} = TestCons.delete_test_con(test_con)
      assert_raise Ecto.NoResultsError, fn -> TestCons.get_test_con!(test_con.id) end
    end

    test "change_test_con/1 returns a test_con changeset" do
      test_con = test_con_fixture()
      assert %Ecto.Changeset{} = TestCons.change_test_con(test_con)
    end
  end
end
