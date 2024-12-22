defmodule YoloPenny.Expenses.Expense do
  @moduledoc """
  The schema for the expense registration form.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:amount, :float)
    field(:description, :string)
    field(:date, :date)
  end

  def changeset(expense, attrs \\ %{}) do
    expense
    |> cast(attrs, [:amount, :description, :date])
    |> validate_required([:amount])
    |> validate_number(:amount, greater_than: 0.0)
  end
end
