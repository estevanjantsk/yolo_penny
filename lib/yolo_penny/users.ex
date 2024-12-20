defmodule YoloPenny.Users do
  @moduledoc """
  This module provides functions for managing users.
  Users API.
  """
  alias YoloPenny.Users.Registration
  alias YoloPenny.Users.UserServer

  def add_user(username) do
    UserServer.add_user(username)
  end

  def find_user(username) do
    UserServer.find_user(username)
  end

  def change_registration(%Registration{} = registration, attrs \\ %{}) do
    registration
    |> Registration.changeset(attrs)
  end
end