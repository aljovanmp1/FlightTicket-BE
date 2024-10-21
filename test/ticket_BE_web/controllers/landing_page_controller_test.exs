defmodule Ticket_BEWeb.LandingPageTest do
  use Ticket_BEWeb.ConnCase

  test "GET /api/public", %{conn: conn} do
    conn = get(conn, ~p"/api/public/")
    assert conn.status == 200
    assert conn.resp_body == "Haii!"
  end
end
