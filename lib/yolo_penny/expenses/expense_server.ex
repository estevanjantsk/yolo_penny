defmodule YoloPenny.Expenses.ExpenseServer do
  @moduledoc """
  This module provides a GenServer for managing user's expenses.
  """

  import Ecto.UUID, only: [generate: 0]

  alias Mix.Tasks.Phx.Gen
  alias YoloPennyWeb.Endpoint

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

  def get_total_by_user(user_id) do
    GenServer.call(__MODULE__, {:get_total_by_user, user_id})
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
    expense = Map.put(expense, :id, generate())

    expense =
      case Map.get(expense, :date) do
        nil -> Map.put(expense, :date, Date.utc_today())
        _ -> expense
      end

    updated_expenses =
      expenses
      |> Map.update(user_id, [expense], fn existing -> [expense | existing] end)

    Endpoint.broadcast("expenses_#{user_id}", "expense_created", expense)

    new_state = %{state | expenses: updated_expenses}

    {:reply, {:ok, expense}, new_state}
  end

  def handle_call({:get_expenses, user_id}, _from, %{expenses: expenses} = state) do
    expenses = Map.get(expenses, user_id, [])

    {:reply, {:ok, expenses}, state}
  end

  def handle_call({:delete_expense, user_id, expense_id}, _from, %{expenses: expenses} = state) do
    expense = get_expense_by_user(expenses, user_id, expense_id)

    updated_expenses =
      expenses
      |> Map.update(user_id, [], fn existing ->
        Enum.filter(existing, fn expense -> expense.id != expense_id end)
      end)

    Endpoint.broadcast("expenses_#{user_id}", "expense_deleted", expense)

    new_state = %{state | expenses: updated_expenses}

    {:reply, {:ok, expense_id}, new_state}
  end

  def handle_call(:clean, _from, _state) do
    {:reply, :ok, %{expenses: %{}}}
  end

  def handle_call({:get_expense_by_id, user_id, expense_id}, _from, %{expenses: expenses} = state) do
    expense = get_expense_by_user(expenses, user_id, expense_id)

    {:reply, {:ok, expense}, state}
  end

  def handle_call({:get_total_by_user, user_id}, _from, %{expenses: expenses} = state) do
    expenses = Map.get(expenses, user_id, [])
    total = Enum.reduce(expenses, 0, fn expense, acc -> acc + expense.amount end)

    {:reply, {:ok, total}, state}
  end

  defp get_expense_by_user(expenses, user_id, expense_id) do
    expenses = Map.get(expenses, user_id, [])
    Enum.find(expenses, fn expense -> expense.id == expense_id end)
  end
end
