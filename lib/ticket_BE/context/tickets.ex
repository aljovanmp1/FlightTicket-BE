defmodule Ticket_BE.Tickets do
  alias Ticket_BE.Repo
  import Ecto.Query, warn: false

  def get_available_tickets(
        flight_date_id,
        class_id,
        total_ticket
      )
      when is_integer(total_ticket) do
    IO.inspect(flight_date_id, label: "Hallo")
    IO.inspect(class_id, label: "Hallo")
    IO.inspect(total_ticket, label: "Hallo")

    sql_cmd = ~c"""
      select
        fd.id as flight_date_id
        , fd.flight_id
        , fd.flight_date
        , as2.flight_class_id
        , as2.price
	      , as2.discount
      from
        flight_date fd
      left join
        available_seat as2 on as2.flight_date_id = fd.id
      where
        fd.id = $1
        and as2.flight_class_id = $2
        and as2.available_seat_total >= $3
    """

    flight_date_id =
      case is_integer(flight_date_id) do
        true -> flight_date_id
        false -> String.to_integer(flight_date_id)
      end

    class_id =
      case is_integer(class_id) do
        true -> class_id
        false -> String.to_integer(class_id)
      end

    params = [
      flight_date_id,
      class_id,
      total_ticket
    ]

    result =
      Repo.query(sql_cmd, params)
      |> IO.inspect(label: "Hallo")

    case result do
      {:ok, res} ->
        if length(res.rows) > 0 do
          {:ok, res}
        else
          {:error, "Ticket not found"}
        end

      {:error, error} ->
        {:error, "Query error: " <> error.postgres.message}

      _ ->
        {:error, "Something went wrong"}
    end
  end

  def get_available_tickets(
        flight_date_id,
        class_id,
        passenggers
      )
      when is_map(passenggers) do
    get_available_tickets(
      flight_date_id,
      class_id,
      get_total_ticket_by_passenger(passenggers)
    )
  end

  def get_total_ticket_by_passenger(passenger) do
    length(passenger["adult"]) + length(passenger["child"])
  end
end
