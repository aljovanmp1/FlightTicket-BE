defmodule Ticket_BE.Passenger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "passengers" do
    belongs_to :order, Ticket_BE.Order
    field :gender_title, :string
    field :full_name, :string
    field :passenger_type_id, :integer
  end

  def changeset(passenger, attr) do
    passenger
    |> cast(attr, [:order_id, :gender_title, :full_name, :passenger_type_id])
    |> validate_required([:order_id, :gender_title, :full_name, :passenger_type_id])
  end
end
