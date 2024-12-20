defmodule YoloPennyWeb.UserSessionController do
  use YoloPennyWeb, :controller

  alias YoloPenny.Users
  alias YoloPennyWeb.UserAuth

  def create(
        conn,
        %{"_action" => "registered", "registration" => %{"username" => username}} = _params
      ) do
    case Users.find_user(username) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account created successfully!")
        |> UserAuth.log_in_user(user)
        |> redirect(to: "/dashboard")

      {:error, :user_not_found} ->
        conn
        |> put_flash(:info, "Something went wrong!")
        |> redirect(to: "/")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
    |> redirect(to: "/users/log_in")
  end
end
