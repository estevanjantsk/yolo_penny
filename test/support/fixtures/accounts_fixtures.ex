defmodule YoloPenny.AccountsFixtures do
  @moduledoc """
  This module provides fixtures for the accounts context.
  """

  def user_fixture(attrs \\ %{}) do
    user = %{id: 1, username: "tester"}
    user = Map.merge(user, attrs)

    {:ok, user}
  end
end
