defmodule CardGameWar do

  defmodule Card do
    defstruct [:rank, :suit]
  end

  def categoria_cartas do
    [:spade, :club, :heart, :diamond]
  end
  @spec rangos :: [:ace | :jack | :king | :queen | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10, ...]
  def rangos do
    [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  end
  def cartas do
    for suit <- categoria_cartas(),
        rank <- rangos() do
      %Card{suit: suit, rank: rank}
    end
  end
  def mas_grande(carta1, carta2) do
    a = Enum.find_index(rangos(), &(&1 == carta1.rank))
    b = Enum.find_index(rangos(), &(&1 == carta2.rank))
    cond do
      a > b -> carta1
      a < b -> carta2
      true ->
         cond do
           Enum.find_index(categoria_cartas(), &(&1 == carta1.suit)) > Enum.find_index(categoria_cartas(), &(&1 == carta2.suit)) -> carta1
           true -> carta2
         end
    end
  end

  def play() do
    {baraja_jugador1, baraja_jugador2} = Enum.shuffle(CardGameWar.cartas) |> Enum.split(26)
    play(26, 26, baraja_jugador1, baraja_jugador2)
  end

  def play(0, _, _, _), do: "gana el jugador 2"
  def play(_, 0, _, _), do: "gana el jugador 1"
  def play(_, _,baraja_jugador1, baraja_jugador2) do
    [carta_jugador1 | baraja_jugador1] = baraja_jugador1
    [carta_jugador2 | baraja_jugador2] = baraja_jugador2
    IO.inspect("jugador 1 juega= " <> inspect(carta_jugador1.rank) <> " " <> inspect(carta_jugador1.suit))
    IO.inspect("jugador 2 juega= " <> inspect(carta_jugador2.rank) <> " " <> inspect(carta_jugador2.suit))

    cond do
      mas_grande(carta_jugador1, carta_jugador2) == carta_jugador1 -> IO.inspect("el jugador 1 gano el round")
        baraja_jugador1 = [carta_jugador1 | Enum.reverse baraja_jugador1]
        baraja_jugador1 = [carta_jugador2 | baraja_jugador1]
        play(length(baraja_jugador1), length(baraja_jugador2), Enum.reverse(baraja_jugador1), baraja_jugador2)

        true ->
        IO.inspect("el jugador 2 gano el round")
        baraja_jugador2 = [carta_jugador2 | Enum.reverse baraja_jugador2]
        baraja_jugador2 = [carta_jugador1 | baraja_jugador2]
        play(length(baraja_jugador1), length(baraja_jugador2), baraja_jugador1, Enum.reverse(baraja_jugador2))
    end
  end
end
