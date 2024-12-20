defmodule YoloPenny.Users.Registration do
  @moduledoc """
  The schema for the user registration form.
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:username, :string)
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:username])
    |> validate_required([:username])
    |> validate_length(:username, min: 5, max: 12)
  end
end
