defmodule Ticket_BEWeb.Orders do
  use Ticket_BEWeb, :controller
  alias Ticket_BE.CreateOrder
  alias Ticket_BE.ErrorHandler.ChangesetError
  alias Ticket_BE.Tickets
  alias Ticket_BE.Orders
  require Logger

  def create(conn, params) do
    try do
      changeset = CreateOrder.changeset(%CreateOrder{}, params)

      if !changeset.valid? do
        conn
        |> put_status(:bad_request)
        |> json(%{
          data: %{},
          errors: ChangesetError.changeset_error_handler(changeset, [:orderer, :passengerDetails])
        })
      else
        tickets =
          Tickets.get_available_tickets(
            params["ticketId"],
            params["classId"],
            params["passengerDetails"]
          )
          |> IO.inspect(label: "ticket")

        case tickets do
          {:ok, data} ->
            [flight_date_id, _, _, _, price, discount] = Enum.at(data.rows, 0)
            # |> IO.inspect(label: "ticket_price")

            user_id = String.to_integer(conn.private.guardian_default_claims["sub"])
            Orders.create_order(
              user_id,
              price-discount,
              Tickets.get_total_ticket_by_passenger(params["passengerDetails"]),
              flight_date_id,
              params["classId"],
              params["orderer"]["fullName"],
              params["orderer"]["phoneNumber"],
              params["orderer"]["email"],
              params["passengerDetails"]
            )

            conn
            |> put_status(:ok)
            |> json(%{data: %{}, msg: :success})

          {:error, msg} ->
            conn
            |> put_status(:bad_request)
            |> json(%{message: msg})
        end

        conn
        |> put_status(:ok)
        |> json(%{data: %{}, msg: :success})
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
