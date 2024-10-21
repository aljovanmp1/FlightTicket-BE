defmodule Ticket_BEWeb.Authentication do
  use Ticket_BEWeb, :controller
  alias Ticket_BE.Users
  alias Ticket_BE.User
  require Logger

  def sign_up(conn, params) do
    try do
      case Users.sign_user(
        params["email"],
        params["password"],
        params["birthDate"],
        params["fullName"],
        params["gender"],
        params["phone_number"]
      ) do
        {:ok, data} ->
          conn
          |> put_status(:ok)
          |> json(%{data: %{}, message: "success"})

        {:error, changeset} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{data: [], errors: [handle_error(changeset.errors)]})
      end
    rescue
      e ->
        Logger.error(e)

        conn
        |> put_status(:internal_server_error)
        |> json(%{message: e.message})
    end
  end

  def sign_in(conn, params)do
    try do
      case Ticket_BE.Guardian.authenticate(
        params["email"],
        params["password"]
      ) do
        {:ok, token, _payload} ->
          conn
          |> put_status(:ok)
          |> json(%{data: %{
            token: token
          }, message: "success"})

          {:error, msg} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{data: [], errors: [msg]})
      end
    rescue
      e ->
        Logger.error(e)

        conn
        |> put_status(:internal_server_error)
        |> json(%{message: e.message})
    end
  end

  def handle_error(resp) do
    {key, {msg, _}} = Enum.at(resp, 0)
    to_string(key) <> ": " <> msg
  end
end
