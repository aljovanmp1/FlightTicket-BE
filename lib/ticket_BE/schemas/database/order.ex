defmodule Ticket_BE.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "order" do
    field :user_id, :integer
    field :order_status_id, :integer
    field :price, :integer
    field :taken_seat, :integer
    field :flight_date_id, :integer
    field :flight_class_id, :string
    field :orderer_email, :string
    field :orderer_phone, :string
    field :orderer_fullname, :string
    field :orderer_code, :string
    has_many :passenger, Ticket_BE.Passenger
  end

  def changeset(order, attr) do
    order
    |> cast(attr, [
      :user_id,
      :order_status_id,
      :price,
      :taken_seat,
      :flight_date_id,
      :flight_class_id,
      :orderer_email,
      :orderer_phone,
      :orderer_fullname,
      :orderer_code
    ])
    |> validate_required([
      :user_id,
      :order_status_id,
      :price,
      :taken_seat,
      :flight_date_id,
      :flight_class_id,
      :orderer_email,
      :orderer_phone,
      :orderer_fullname,
      :orderer_code
    ])
  end
end
