defmodule YoloPennyWeb.DashboardLive.FormComponent do
  use YoloPennyWeb, :live_component

  alias YoloPenny.Expenses
  alias YoloPenny.Expenses.Expense

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> clear_form()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Use this form to add a new expense.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="expense-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="flex gap-3">
          <div class="flex-grow">
            <.input field={@form[:amount]} type="number" label="Amount" />
          </div>
          <div class="flex-grow">
            <.input field={@form[:date]} type="date" label="Date" />
          </div>
        </div>
        <.input field={@form[:description]} type="text" label="Description" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Expense</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset =
      Expenses.change_expense(%Expense{}, expense_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    changeset =
      Expenses.change_expense(%Expense{}, expense_params)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, data} ->
        Expenses.add_expense(socket.assigns.current_user.id, data)

        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, changeset} ->
        socket =
          socket
          |> assign_form(changeset)

        {:noreply, socket}
    end
  end

  def clear_form(socket) do
    assign_form(socket, Expenses.change_expense(%Expense{}))
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
