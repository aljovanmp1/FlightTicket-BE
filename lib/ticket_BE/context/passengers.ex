defmodule Ticket_BE.Passengers do
  alias Ticket_BE.Repo
  import Ecto.Query, warn: false

  def insert_passengers(data_arr) do
    types = get_passengers_type()
    IO.inspect(data_arr, label: "data arr")
    arranged_data = data_arr
    |> Enum.map(fn x ->
      %{
        full_name: x.full_name,
        gender_title: change_gender_title(x.gender_title),
        order_id: x.order_id,
        passenger_type_id: determine_passenger_type_id(x.type, types)
      }
    end)
    Repo.insert_all(Ticket_BE.Passenger, arranged_data)
    |> IO.inspect(label: "resp")
  end

  defp determine_passenger_type_id(type, all_types) do
    selected = Enum.filter(all_types, fn x ->
      x.name == type
    end)
    Enum.at(selected,0).id
  end

  defp change_gender_title(gender) do
    case gender do
      "Tuan" -> "MR"
      "Nyonya" -> "MRS"
      "Nona" -> "MISS"
    end
  end

  defp get_passengers_type() do
    Repo.all(
      from(pt in "passenger_type",
            select: %{id: pt.id, name: pt.name}
      )
    )
  end
end
