defmodule YoloPennyWeb.UserRegistrationLive do
  use YoloPennyWeb, :live_view

  alias YoloPenny.Users
  alias YoloPenny.Users.Registration

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(trigger_submit: false, check_errors: false)
     |> assign_registration()
     |> clear_form()}
  end

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:username]} label="Username" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def handle_event(
        "save",
        %{"registration" => registration_params},
        %{assigns: %{registration: registration}} = socket
      ) do
    changeset =
      Users.change_registration(registration, registration_params)

    with true <- changeset.valid?,
         {:ok, _user} <- Users.add_user(registration_params["username"]) do
      socket =
        socket |> assign(trigger_submit: true) |> clear_form()

      {:noreply, socket}
    else
      {:error, :user_exists} ->
        socket =
          socket
          |> assign_registration
          |> clear_form()
          |> put_flash(:error, "Oops, something went wrong! Please try again.")

        {:noreply, socket}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_event(
        "validate",
        %{"registration" => registration_params},
        %{assigns: %{registration: registration}} = socket
      ) do
    changeset =
      Users.change_registration(registration, registration_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def assign_registration(socket) do
    socket
    |> assign(:registration, %Registration{})
  end

  def assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset))
  end

  def clear_form(socket) do
    form =
      socket.assigns.registration
      |> Users.change_registration()
      |> to_form()

    assign(socket, form: form)
  end
end
