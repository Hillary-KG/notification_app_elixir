defmodule NotifAppWeb.UserDashboardLiveTest do
  use NotifAppWeb.ConnCase

  import Phoenix.LiveViewTest
  import NotifApp.UserDashboardsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_user_dashboard(_) do
    user_dashboard = user_dashboard_fixture()
    %{user_dashboard: user_dashboard}
  end

  describe "Index" do
    setup [:create_user_dashboard]

    test "lists all user_dashboards", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/user_dashboards")

      assert html =~ "Listing User dashboards"
    end

    test "saves new user_dashboard", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/user_dashboards")

      assert index_live |> element("a", "New User dashboard") |> render_click() =~
               "New User dashboard"

      assert_patch(index_live, ~p"/user_dashboards/new")

      assert index_live
             |> form("#user_dashboard-form", user_dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_dashboard-form", user_dashboard: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_dashboards")

      html = render(index_live)
      assert html =~ "User dashboard created successfully"
    end

    test "updates user_dashboard in listing", %{conn: conn, user_dashboard: user_dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/user_dashboards")

      assert index_live |> element("#user_dashboards-#{user_dashboard.id} a", "Edit") |> render_click() =~
               "Edit User dashboard"

      assert_patch(index_live, ~p"/user_dashboards/#{user_dashboard}/edit")

      assert index_live
             |> form("#user_dashboard-form", user_dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_dashboard-form", user_dashboard: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/user_dashboards")

      html = render(index_live)
      assert html =~ "User dashboard updated successfully"
    end

    test "deletes user_dashboard in listing", %{conn: conn, user_dashboard: user_dashboard} do
      {:ok, index_live, _html} = live(conn, ~p"/user_dashboards")

      assert index_live |> element("#user_dashboards-#{user_dashboard.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#user_dashboards-#{user_dashboard.id}")
    end
  end

  describe "Show" do
    setup [:create_user_dashboard]

    test "displays user_dashboard", %{conn: conn, user_dashboard: user_dashboard} do
      {:ok, _show_live, html} = live(conn, ~p"/user_dashboards/#{user_dashboard}")

      assert html =~ "Show User dashboard"
    end

    test "updates user_dashboard within modal", %{conn: conn, user_dashboard: user_dashboard} do
      {:ok, show_live, _html} = live(conn, ~p"/user_dashboards/#{user_dashboard}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User dashboard"

      assert_patch(show_live, ~p"/user_dashboards/#{user_dashboard}/show/edit")

      assert show_live
             |> form("#user_dashboard-form", user_dashboard: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_dashboard-form", user_dashboard: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/user_dashboards/#{user_dashboard}")

      html = render(show_live)
      assert html =~ "User dashboard updated successfully"
    end
  end
end
