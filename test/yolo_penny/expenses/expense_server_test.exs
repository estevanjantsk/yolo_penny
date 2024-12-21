defmodule YoloPenny.Expenses.ExpenseServerTest do
  use ExUnit.Case

  alias YoloPenny.Expenses.ExpenseServer

  setup do
    ExpenseServer.clean()
  end

  test "add_expense/2 adds an expense to the list" do
    {:ok, _} = ExpenseServer.add_expense("alice", %{id: 1, amount: 100})
    {:ok, _} = ExpenseServer.add_expense("alice", %{id: 2, amount: 200})

    {:ok, expenses} = ExpenseServer.get_expenses("alice")

    assert expenses == [%{id: 2, amount: 200}, %{id: 1, amount: 100}]
  end

  test "get_expenses/1 returns an empty list if the user does not exist" do
    {:ok, expenses} = ExpenseServer.get_expenses("bob")
    assert expenses == []
  end

  test "delete_expense/2 deletes an expense from the list" do
    {:ok, _} = ExpenseServer.add_expense("alice", %{id: 1, amount: 100})
    {:ok, _} = ExpenseServer.add_expense("alice", %{id: 2, amount: 200})

    {:ok, _} = ExpenseServer.delete_expense("alice", 1)

    {:ok, expenses} = ExpenseServer.get_expenses("alice")

    assert expenses == [%{id: 2, amount: 200}]
  end
end
