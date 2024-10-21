defmodule Ticket_BEWeb.FlightTest do
  use Ticket_BEWeb.ConnCase

  test "GET api/public/flight/airports", %{conn: conn} do
    conn = get(conn, ~p"/api/public/flight/airports")
    assert conn.status == 200
    {:ok, data} = Jason.decode(conn.resp_body)
    assert length(data["data"]) > 0
  end

  test "GET api/public/flight/class", %{conn: conn} do
    conn = get(conn, ~p"/api/public/flight/class")
    assert conn.status == 200
    {:ok, data} = Jason.decode(conn.resp_body)
    assert length(data["data"]) > 0
  end

  describe "GET api/public/flight/tickets" do
    test "No class id", %{conn: conn} do
      params = %{
          passenger: %{
            adult: 1,
            infant: 1,
            child: 1
          },
          arrivalCode: "JKTA",
          departureCode: "YKIA",
          departureDateStart: "2024-01-22T17:00:00.000Z",
          departureDateEnd: "2024-01-23T17:00:00.000Z",
          airlineId: [],
          sortBy: ["price"],
          page: 0,
          dataPerPage: 10
        }

      conn = post(conn, ~p"/api/public/flight/tickets", params)

      assert conn.status == 400
      {:ok, data} = Jason.decode(conn.resp_body)
      error = Enum.at(data["errors"], 0)
      expected = %{
        "msg" => "can't be blank",
        "key" => "classId"
      }
      assert error == expected
    end
  end
end
