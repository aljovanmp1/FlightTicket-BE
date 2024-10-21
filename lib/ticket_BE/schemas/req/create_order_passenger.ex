defmodule Ticket_BE.CreateOrderPassenger do
  use Ecto.Schema
  import Ecto.Changeset

  schema "createorderpassenger" do
    field :adult, {:array, :string}
    field :child, {:array, :string}
    field :infant, {:array, :string}
    belongs_to :orderer, Ticket_BE.CreateOrder
  end

  def changeset(passenger, attrs) do
    passenger
    |> cast(attrs, [
      :adult,
      :child,
      :infant
    ])
    |> validate_required([
      :adult
    ])
    |> validate_change(:adult, &validate_format_passenger(&1, &2, ~r/^(Tuan|Nona|Nyonya)\s/))
    |> validate_change(:child, &validate_format_passenger(&1, &2, ~r/^(Tuan|Nona|Nyonya)\s/))
    |> validate_change(:infant, &validate_format_passenger(&1, &2, ~r/^(Tuan|Nona|Nyonya)\s/))
  end

  def validate_format_passenger(field, value, regex) do
    isMatch =
      value
      |> Enum.all?(fn value -> String.match?(value, regex) end)
      |> IO.inspect(label: "format_passenger")

    if isMatch do
      []
    else
      [{field, "Only accept Tuan, Nona, Or Nyonya"}]
    end
  end
end
