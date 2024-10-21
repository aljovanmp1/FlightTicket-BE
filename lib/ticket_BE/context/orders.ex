defmodule Ticket_BE.Orders do
  alias Ticket_BE.Repo
  import Ecto.Query, warn: false
  alias Ticket_BE.Order
  alias Ticket_BE.Passengers

  def insert_order(
        user_id,
        price,
        taken_seat,
        flight_date_id,
        flight_class_id,
        orderer_email,
        orderer_phone,
        orderer_fullname
      ) do
    attr =
      %{
        user_id: user_id,
        price: price,
        taken_seat: taken_seat,
        flight_date_id: flight_date_id,
        flight_class_id: flight_class_id,
        orderer_email: orderer_email,
        orderer_phone: orderer_phone,
        orderer_fullname: orderer_fullname
      }
      |> IO.inspect(label: "asd")

    sql_cmd = ~c"""
      INSERT INTO orders
      (
        user_id,
        payment_status_id,
        price,
        taken_seat,
        ticket_id,
        flight_class_id,
        orderer_email,
        orderer_phone,
        orderer_fullname,
        order_code
      )
      VALUES (
        $1,
        (SELECT id FROM payment_status where name = 'paid'),
        $2,
        $3,
        $4,
        $5,
        $6,
        $7,
        $8,
        (SELECT generate_random_string(6))
      )
      RETURNING *
    """

    params = [
      user_id,
      price,
      taken_seat,
      flight_date_id,
      flight_class_id,
      orderer_email,
      orderer_phone,
      orderer_fullname
    ]

    result =
      Repo.query(sql_cmd, params)
      |> IO.inspect(labels: "data insert")
  end

  def create_order(
        user_id,
        price,
        taken_seat,
        flight_date_id,
        flight_class_id,
        orderer_email,
        orderer_phone,
        orderer_fullname,
        passengers
      ) do
    Repo.transaction(fn ->
      with {:ok, order_data} <-
             insert_order(
               user_id,
               price,
               taken_seat,
               flight_date_id,
               flight_class_id,
               orderer_email,
               orderer_phone,
               orderer_fullname
             ),
           {_, nil} <-
             Passengers.insert_passengers(
               arrange_passengers(passengers, Enum.at(Enum.at(order_data.rows, 0), 0))
             ) do
        {:ok, "success"}
      else
        {:error, err} ->
          Repo.rollback(err)
      end
    end)
  end

  defp arrange_passengers(passengers, order_id) do
    types =
      ["adult", "child", "infant"]
      |> Enum.reduce([], fn type, acc ->
        data =
          Enum.map(passengers[type], fn x ->
            splitted = String.split(x, " ")
            %{
              full_name: Enum.at(splitted, 1),
              gender_title: Enum.at(splitted, 0),
              order_id: order_id,
              type: type
            }
          end)

        acc = acc ++ data
      end)
  end
end
