defmodule Ticket_BE.CreateOrderOrderer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "createorderorderer" do
    field :fullName, :string
    field :phoneNumber, :string
    field :email, :string
    belongs_to :orderer, Ticket_BE.CreateOrder
  end

  def changeset(orderer, attrs) do
    orderer
    |> cast(attrs, [
      :fullName,
      :phoneNumber,
      :email
    ])
    |> validate_required([
      :fullName,
      :phoneNumber,
      :email
    ])
    |> validate_format(:email, ~r/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/)
    |> validate_format(:fullName, ~r/^(Tuan|Nona|Nyonya)\s/,
      message: "Only accept Tuan, Nona, Or Nyonya"
    )
  end

  # defp validate_email_format(changeset, field) do
  #   validate_format(changeset, field, ~r/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "is not a valid email address")
  # end
end
