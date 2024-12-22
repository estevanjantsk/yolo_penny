defmodule YoloPenny.Expenses do
  @moduledoc """
  This module provides functions for managing expenses.
  Expenses API.
  """

  alias YoloPenny.Expenses.Expense
  alias YoloPenny.Expenses.ExpenseServer

  def add_expense(user_id, expense), do: ExpenseServer.add_expense(user_id, expense)

  def get_expense_by_user(user_id, expense_id),
    do: ExpenseServer.get_expense_by_id(user_id, expense_id)

  def get_total_by_user(user_id), do: ExpenseServer.get_total_by_user(user_id)

  def get_expenses_by_user(user_id), do: ExpenseServer.get_expenses(user_id)

  def delete_expense_by_user(user_id, expense_id),
    do: ExpenseServer.delete_expense(user_id, expense_id)

  def clean_expenses, do: ExpenseServer.clean()

  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    expense
    |> Expense.changeset(attrs)
  end
end
