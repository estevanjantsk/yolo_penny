defmodule YoloPenny.Users.UserServerTest do
  use ExUnit.Case, async: true

  alias YoloPenny.Users.UserServer

  setup do
    UserServer.clean()
    :ok
  end

  test "add_user/1 adds a user to the list" do
    {:ok, user} = UserServer.add_user("alice")

    assert user.username == "alice"
  end

  test "add_user/1 returns an error if the user already exists" do
    UserServer.add_user("alice")

    assert {:error, :user_exists} = UserServer.add_user("alice")
  end

  test "list_users/0 returns a list of users" do
    UserServer.add_user("alice")
    UserServer.add_user("bob")
    users = UserServer.list_users()

    assert Enum.count(users) == 2
  end

  test "find_user/1 returns the user if it exists" do
    UserServer.add_user("alice")
    UserServer.add_user("bob")

    {:ok, user} = UserServer.find_user("alice")

    assert user.username == "alice"
  end

  test "clean/0 removes all users" do
    UserServer.add_user("alice")
    UserServer.add_user("bob")
    users = UserServer.list_users()

    assert Enum.count(users) == 2

    UserServer.clean()

    users = UserServer.list_users()

    assert Enum.empty?(users) == true
  end
end
