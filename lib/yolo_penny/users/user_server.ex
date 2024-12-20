defmodule YoloPenny.Users.UserServer do
  @moduledoc """
  This module provides a GenServer for managing users.
  """

  use GenServer

  # Client API

  # Starts the GenServer with an empty list of users
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{users: %{}}, name: __MODULE__)
  end

  # Adds a user only if the username does not exist in the list
  def add_user(username) do
    GenServer.call(__MODULE__, {:add_user, username})
  end

  # Lists all users (for debugging purposes)
  def list_users do
    GenServer.call(__MODULE__, :list_users)
  end

  # Cleans the list of users (for debugging purposes)
  def clean do
    GenServer.call(__MODULE__, :clean)
  end

  # Server Callbacks

  # Initialize the state as an empty map (keyed by `username`)
  def init(initial_state) do
    {:ok, initial_state}
  end

  # Handle the add_user request
  def handle_call({:add_user, username}, _from, %{users: users} = state) do
    if Map.has_key?(users, username) do
      {:reply, {:error, :user_exists}, state}
    else
      id_counter = map_size(state.users) + 1
      user = %{id: id_counter, username: username}
      new_users = Map.put(users, username, user)
      new_state = %{state | users: new_users}
      {:reply, {:ok, user}, new_state}
    end
  end

  # Handle list_users request
  def handle_call(:list_users, _from, state) do
    {:reply, Map.values(state.users), state}
  end

  # Handle clean request
  def handle_call(:clean, _from, _state) do
    {:reply, :ok, %{users: %{}}}
  end
end
