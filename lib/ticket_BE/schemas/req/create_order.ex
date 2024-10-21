defmodule Ticket_BE.CreateOrder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "createorder" do
    field :ticketId, :integer
    field :classId, :integer
    has_one :orderer, Ticket_BE.CreateOrderOrderer
    has_one :passengerDetails, Ticket_BE.CreateOrderPassenger
    # field :passengerDetails, :map
  end

  def changeset(create_order, attrs) do
    create_order
    |> cast(attrs, [
      :ticketId,
      :classId,
    ])
    |> cast_assoc(:orderer, with: &Ticket_BE.CreateOrderOrderer.changeset/2)
    |> cast_assoc(:passengerDetails, with: &Ticket_BE.CreateOrderPassenger.changeset/2)
    |> validate_required([
      :ticketId,
      :classId,
      :orderer,
      :passengerDetails
    ])
  end
end
