defmodule YoloPennyWeb.UserAuth do
  @moduledoc """
  This module provides functions for managing user authentication.
  """

  use YoloPennyWeb, :verified_routes

  import Plug.Conn

  def log_in_user(conn, user) do
    conn
    |> put_session(:current_user, user)
  end

  def log_out_user(conn) do
    conn
    |> delete_session(:current_user)
  end

  def fetch_current_user(conn, _opts) do
    current_user = get_session(conn, :current_user)
    assign(conn, :current_user, current_user)
  end

  # Defining hooks for LiveView routes
  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_current_user(socket, session)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/users/log_in")

      {:halt, socket}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_current_user(socket, session)

    if socket.assigns.current_user do
      {:halt, Phoenix.LiveView.redirect(socket, to: ~p"/dashboard")}
    else
      {:cont, socket}
    end
  end

  defp mount_current_user(socket, session) do
    Phoenix.Component.assign_new(socket, :current_user, fn ->
      if username = session["current_user"] do
        username
      end
    end)
  end
end
