defmodule Ticket_BEWeb.ErrorController do
  use Ticket_BEWeb, :controller

  def not_found(conn, _params) do
    conn
    |> put_status(:not_found)
    |> json(%{error: "Page not found"})
  end
end
