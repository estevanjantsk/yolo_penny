defmodule YoloPenny.ExpensesFixtures do
  @moduledoc """
  This module provides fixtures for the expenses context.
  """
  alias YoloPenny.Expenses

  def expense_fixture(username \\ "tester") do
    {:ok, expense} =
      Expenses.add_expense(username, %{amount: 1, description: "test", date: ~D[2021-01-01]})

    expense
  end
end
