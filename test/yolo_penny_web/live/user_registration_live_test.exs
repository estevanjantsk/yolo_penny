defmodule YoloPennyWeb.UserRegistrationLiveTest do
  use YoloPennyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import YoloPenny.AccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end
  end

  test "redirects if already logged in", %{conn: conn} do
    result =
      conn
      |> log_in_user(user_fixture())
      |> live(~p"/users/register")
      |> follow_redirect(conn, "/dashboard")

    assert {:ok, _conn} = result
  end

  test "renders errors for invalid data", %{conn: conn} do
    {:ok, lv, _html} = live(conn, ~p"/users/register")

    result =
      lv
      |> element("#registration_form")
      |> render_change(registration: %{"username" => "with"})

    assert result =~ "Register"
    assert result =~ "should be at least 5 character"
  end
end
