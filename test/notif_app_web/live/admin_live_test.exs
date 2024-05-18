defmodule NotifAppWeb.AdminLiveTest do
  use NotifAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import NotifApp.AdminsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_admin(_) do
    admin = admin_fixture()
    %{admin: admin}
  end

  describe "Index" do
    setup [:create_admin]

    test "lists all admins", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/admins")

      assert html =~ "Listing Admins"
    end

    test "saves new admin", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admins")

      assert index_live |> element("a", "New Admin") |> render_click() =~
               "New Admin"

      assert_patch(index_live, ~p"/admins/new")

      assert index_live
             |> form("#admin-form", admin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#admin-form", admin: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admins")

      html = render(index_live)
      assert html =~ "Admin created successfully"
    end

    test "updates admin in listing", %{conn: conn, admin: admin} do
      {:ok, index_live, _html} = live(conn, ~p"/admins")

      assert index_live |> element("#admins-#{admin.id} a", "Edit") |> render_click() =~
               "Edit Admin"

      assert_patch(index_live, ~p"/admins/#{admin}/edit")

      assert index_live
             |> form("#admin-form", admin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#admin-form", admin: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admins")

      html = render(index_live)
      assert html =~ "Admin updated successfully"
    end

    test "deletes admin in listing", %{conn: conn, admin: admin} do
      {:ok, index_live, _html} = live(conn, ~p"/admins")

      assert index_live |> element("#admins-#{admin.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#admins-#{admin.id}")
    end
  end

  describe "Show" do
    setup [:create_admin]

    test "displays admin", %{conn: conn, admin: admin} do
      {:ok, _show_live, html} = live(conn, ~p"/admins/#{admin}")

      assert html =~ "Show Admin"
    end

    test "updates admin within modal", %{conn: conn, admin: admin} do
      {:ok, show_live, _html} = live(conn, ~p"/admins/#{admin}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Admin"

      assert_patch(show_live, ~p"/admins/#{admin}/show/edit")

      assert show_live
             |> form("#admin-form", admin: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#admin-form", admin: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admins/#{admin}")

      html = render(show_live)
      assert html =~ "Admin updated successfully"
    end
  end
end
