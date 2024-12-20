defmodule YoloPennyWeb.UserLoginLive do
  use YoloPennyWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, user: %{})}
  end

  def render(assigns) do
    ~H"""
    <div>
      User Login
    </div>
    """
  end
end
