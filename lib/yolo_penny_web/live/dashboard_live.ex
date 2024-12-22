defmodule YoloPennyWeb.DashboardLive do
  alias YoloPenny.Expenses
  alias YoloPenny.Expenses.Expense
  use YoloPennyWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign_expenses}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.title_bar>
      My Expenses
      <:actions>
        <.button
          id="expense-btn"
          phx-click={JS.push("new")}
          class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
        >
          <.icon name="hero-add-new" /><span class="ml-2">New Expense</span>
        </.button>
      </:actions>
    </.title_bar>

    <div class="bg-gray-200 text-gray-700 p-2 mt-2">
      Total: 100
    </div>

    <.table id="expenses" rows={@streams.expenses}>
      <:col :let={{_id, expense}} label="Description"><%= expense.description %></:col>
      <:col :let={{_id, expense}} label="Amount"><%= expense.amount %></:col>
      <%!-- <:col :let={{_id, expense}} label="Date"><%= expense.date %></:col> --%>
      <:action :let={{id, expense}}>
        <.link
          phx-click={JS.push("delete", value: %{id: expense.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          <.icon name="hero-trash-solid" class="h-4 w-4" /> Delete
        </.link>
      </:action>
    </.table>

    <.modal :if={@live_action == :new} id="expense-modal" show on_cancel={JS.patch(~p"/dashboard")}>
      <.live_component
        module={YoloPennyWeb.DashboardLive.FormComponent}
        id={:new}
        title={@page_title}
        action={@live_action}
        patch={~p"/dashboard"}
      />
    </.modal>
    """
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "My Expenses")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_id = socket.assigns.current_user.id

    {:ok, expense} = Expenses.get_expense_by_user(user_id, id)
    {:ok, _} = Expenses.delete_expense_by_user(user_id, id)

    {:noreply, stream_delete(socket, :expenses, expense)}
  end

  @impl true
  def handle_event("new", _, socket) do
    {:noreply, push_patch(socket, to: ~p"/dashboard/new-expense")}
  end

  def assign_expenses(socket) do
    user_id = socket.assigns.current_user.id
    {:ok, expenses} = Expenses.get_expenses_by_user(user_id)

    stream(socket, :expenses, expenses)
  end
end
