defmodule YoloPenny.Expenses.ExpenseServer do
  @moduledoc """
  This module provides a GenServer for managing user's expenses.
  """

  use GenServer

  # Public API

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{expenses: %{}}, name: __MODULE__)
  end

  def add_expense(user_id, expense) do
    GenServer.call(__MODULE__, {:add_expense, user_id, expense})
  end

  def get_expenses(user_id) do
    GenServer.call(__MODULE__, {:get_expenses, user_id})
  end

  def get_expense_by_id(user_id, expense_id) do
    GenServer.call(__MODULE__, {:get_expense_by_id, user_id, expense_id})
  end

  def delete_expense(user_id, expense_id) do
    GenServer.call(__MODULE__, {:delete_expense, user_id, expense_id})
  end

  def clean do
    GenServer.call(__MODULE__, :clean)
  end

  # Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:add_expense, user_id, expense}, _from, %{expenses: expenses} = state) do
    updated_expenses =
      expenses
      |> Map.update(user_id, [expense], fn existing -> [expense | existing] end)

    new_state = %{state | expenses: updated_expenses}

    {:reply, {:ok, expense}, new_state}
  end

  def handle_call({:get_expenses, user_id}, _from, %{expenses: expenses} = state) do
    expenses = Map.get(expenses, user_id, [])

    {:reply, {:ok, expenses}, state}
  end

  def handle_call({:delete_expense, user_id, expense_id}, _from, %{expenses: expenses} = state) do
    updated_expenses =
      expenses
      |> Map.update(user_id, [], fn existing ->
        Enum.filter(existing, fn expense -> expense.id != expense_id end)
      end)

    new_state = %{state | expenses: updated_expenses}

    {:reply, {:ok, expense_id}, new_state}
  end

  def handle_call(:clean, _from, _state) do
    {:reply, :ok, %{expenses: %{}}}
  end

  def handle_call({:get_expense_by_id, user_id, expense_id}, _from, %{expenses: expenses} = state) do
    expenses = Map.get(expenses, user_id, [])
    expense = Enum.find(expenses, fn expense -> expense.id == expense_id end)

    {:reply, {:ok, expense}, state}
  end
end
