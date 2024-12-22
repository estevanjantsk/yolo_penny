defmodule YoloPennyWeb.DashboardLiveTest do
  alias YoloPenny.Expenses
  alias YoloPenny.Users
  use YoloPennyWeb.ConnCase, async: true

  import Phoenix.LiveViewTest
  import YoloPenny.AccountsFixtures
  import YoloPenny.ExpensesFixtures

  @invalid_attrs %{amount: nil, description: nil, date: nil}
  @create_attrs %{amount: 1, description: nil, date: nil}

  setup %{conn: conn} do
    Users.clean_users()
    Expenses.clean_expenses()

    user = user_fixture("joinha")

    conn =
      conn
      |> log_in_user(user)

    {:ok, conn: conn, user: user}
  end

  describe "Dashboard page" do
    test "renders dashboard page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/dashboard")

      assert html =~ "My Expenses"
    end

    test "create new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/dashboard")

      assert index_live |> element("button", "New Expense") |> render_click() =~
               "New Expense"

      assert_patch(index_live, ~p"/dashboard/new-expense")

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#expense-form", expense: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/dashboard")

      html = render(index_live)
      assert html =~ "Expense created successfully"
      assert html =~ "1.0"
    end

    test "deletes expense in listing", %{conn: conn, user: user} do
      expense = expense_fixture(user.id)

      {:ok, index_live, _html} = live(conn, ~p"/dashboard")

      assert index_live |> element("#expenses-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expenses-#{expense.id}")
    end
  end
end
