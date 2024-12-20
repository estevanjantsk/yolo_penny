defmodule YoloPennyWeb.UserAuthTest do
  use YoloPennyWeb.ConnCase, async: true

  alias YoloPennyWeb.UserAuth
  alias Phoenix.LiveView

  import YoloPenny.AccountsFixtures

  setup %{conn: conn} do
    conn =
      conn |> init_test_session(%{})

    {:ok, user} = user_fixture()

    %{user: user, conn: conn}
  end

  test "log_in_user/2 logs in a user", %{conn: conn, user: user} do
    conn = UserAuth.log_in_user(conn, user)

    assert get_session(conn, :current_user) == %{id: 1, username: "tester"}
  end

  test "log_out_user/1 logs out a user", %{conn: conn, user: user} do
    conn = UserAuth.log_in_user(conn, user)

    conn = UserAuth.log_out_user(conn)

    assert get_session(conn, :current_user) == nil
  end

  test "fetch_current_user/2 fetches the current user", %{conn: conn, user: user} do
    conn = UserAuth.log_in_user(conn, user)

    conn = UserAuth.fetch_current_user(conn, %{})

    assert conn.assigns.current_user == %{id: 1, username: "tester"}
  end

  describe "on_mount/4 :ensure_authenticated" do
    test "ensures a user is authenticated", %{conn: conn, user: user} do
      conn = UserAuth.log_in_user(conn, user)

      session = conn |> get_session()

      {:cont, socket} = UserAuth.on_mount(:ensure_authenticated, %{}, session, %LiveView.Socket{})

      assert socket.assigns.current_user == %{id: 1, username: "tester"}
    end

    test "on_mount/4 redirects if a user is not authenticated", %{conn: conn} do
      session = conn |> get_session()

      socket = %LiveView.Socket{
        endpoint: PentoWeb.Endpoint,
        assigns: %{__changed__: %{}, flash: %{}}
      }

      assert {:halt, _socket} =
               UserAuth.on_mount(
                 :ensure_authenticated,
                 %{},
                 session,
                 socket
               )
    end
  end

  describe "on_mount/4 :redirect_if_user_is_authenticated" do
    test "redirects if a user is authenticated", %{conn: conn, user: user} do
      conn = UserAuth.log_in_user(conn, user)

      session = conn |> get_session()

      assert {:halt, _socket} =
               UserAuth.on_mount(
                 :redirect_if_user_is_authenticated,
                 %{},
                 session,
                 %LiveView.Socket{}
               )
    end

    test "doesn't redirect if there is no authenticated user", %{conn: conn} do
      session = conn |> get_session()

      assert {:cont, _updated_socket} =
               UserAuth.on_mount(
                 :redirect_if_user_is_authenticated,
                 %{},
                 session,
                 %LiveView.Socket{}
               )
    end
  end
end
