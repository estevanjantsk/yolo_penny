defmodule YoloPennyWeb.UserSessionController do
  use YoloPennyWeb, :controller

  alias YoloPenny.Users
  alias YoloPennyWeb.UserAuth

  def create(
        conn,
        %{"_action" => "registered", "registration" => %{"username" => username}} = _params
      ) do
    create(conn, username, "Account created successfully!", "/users/register")
  end

  def create(
        conn,
        %{
          "user" => %{"username" => username}
        } = _params
      ) do
    create(conn, username, "Welcome back!", "/users/log_in")
  end

  defp create(conn, username, info, redirect_to) do
    case Users.find_user(username) do
      {:ok, user} ->
        conn
        |> put_flash(:info, info)
        |> UserAuth.log_in_user(user)
        |> redirect(to: "/dashboard")

      {:error, :user_not_found} ->
        conn
        |> put_flash(:error, "Something went wrong!")
        |> redirect(to: redirect_to)
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out.")
    |> UserAuth.log_out_user()
    |> redirect(to: "/users/log_in")
  end
end
