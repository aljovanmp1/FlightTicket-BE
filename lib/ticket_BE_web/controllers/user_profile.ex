defmodule Ticket_BEWeb.UserProfile do
  use Ticket_BEWeb, :controller
  alias Ticket_BE.Users
  require Logger

  def get_profile(conn, params) do
    try do
      id = String.to_integer(conn.private.guardian_default_claims["sub"])
      case Users.get_user_profile(id) do
        {:ok, data} ->
          conn
          |> put_status(:ok)
          |> json(%{data: data})
        {:error, msg} ->
          conn
          |> put_status(:internal_server_error)
          |> json(%{msg: msg})
      end

    rescue
      e ->
        Logger.error(e)

        conn
        |> put_status(:internal_server_error)
        |> json(%{message: e.message})
    end
  end
end
