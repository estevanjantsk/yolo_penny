defmodule YoloPenny.Expenses.ExpenseServerTest do
  use ExUnit.Case

  alias YoloPenny.Expenses.ExpenseServer

  setup do
    ExpenseServer.clean()
  end

  test "add_expense/2 adds an expense to the list" do
    {:ok, _} = ExpenseServer.add_expense("alice", %{amount: 100})
    {:ok, _} = ExpenseServer.add_expense("alice", %{amount: 200})

    {:ok, expenses} = ExpenseServer.get_expenses("alice")

    assert Enum.count(expenses) == 2
  end

  test "get_expenses/1 returns an empty list if the user does not exist" do
    {:ok, expenses} = ExpenseServer.get_expenses("bob")
    assert expenses == []
  end

  test "delete_expense/2 deletes an expense from the list" do
    {:ok, expense} = ExpenseServer.add_expense("alice", %{amount: 100})
    {:ok, _} = ExpenseServer.add_expense("alice", %{amount: 200})

    {:ok, _} = ExpenseServer.delete_expense("alice", expense.id)

    {:ok, expenses} = ExpenseServer.get_expenses("alice")

    assert Enum.count(expenses) == 1
  end

  test "get_expense_by_id/2 returns the expense with the given id" do
    {:ok, expense} = ExpenseServer.add_expense("alice", %{amount: 100})
    {:ok, _} = ExpenseServer.add_expense("alice", %{amount: 200})

    {:ok, found_expense} = ExpenseServer.get_expense_by_id("alice", expense.id)

    assert found_expense.id == expense.id
  end

  test "get_total_by_user/1 returns the total amount of expenses for the user" do
    {:ok, _} = ExpenseServer.add_expense("alice", %{amount: 100})
    {:ok, _} = ExpenseServer.add_expense("alice", %{amount: 200})

    {:ok, total} = ExpenseServer.get_total_by_user("alice")

    assert total == 300
  end
end
