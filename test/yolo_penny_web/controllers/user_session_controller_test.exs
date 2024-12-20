defmodule YoloPennyWeb.UserSessionControllerTest do
  use YoloPennyWeb.ConnCase

  alias YoloPenny.Users
  import YoloPenny.AccountsFixtures

  setup do
    Users.clean_users()

    user = user_fixture()

    %{user: user}
  end

  describe "POST /users/log_in" do
    test "creates a session for the user", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{"username" => user.username}
        })

      assert get_session(conn, :current_user)
    end

    test "redirects to the log in page if the user is not found", %{conn: conn} do
      conn =
        post(conn, ~p"/users/log_in", %{
          "user" => %{"username" => "unknown"}
        })

      assert redirected_to(conn) == "/users/log_in"
    end
  end

  describe "POST /users/log_in?_action=registered" do
    test "creates a session for the user", %{conn: conn, user: user} do
      conn =
        post(conn, ~p"/users/log_in?_action=registered", %{
          "registration" => %{"username" => user.username}
        })

      assert get_session(conn, :current_user)
    end

    test "redirects to the log in page if the user is not found", %{conn: conn} do
      conn =
        post(conn, ~p"/users/log_in?_action=registered", %{
          "registration" => %{"username" => "unknown"}
        })

      assert redirected_to(conn) == "/users/register"
    end
  end
end
