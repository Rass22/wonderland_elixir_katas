defmodule CardGameWar_Test do
  use ExUnit.Case
  doctest BecariosBunsan2022B1

  test "the highest rank wins the cards in the round" do
    assert CardGameWar.get_higher(%Card{suit: :diamond, rank: 8}, %Card{suit: :spade, rank: 2}) ==
      %Card{suit: :diamond, rank: 8}
  end

  test "queens are higher rank than jacks" do
    assert CardGameWar.get_higher(%Card{suit: :diamond, rank: :queen}, %Card{suit: :spade, rank: :jack}) ==
      %Card{suit: :diamond, rank: :queen}
  end

  test "kings are higher rank than queens" do
    assert CardGameWar.get_higher(%Card{suit: :heart, rank: :queen}, %Card{suit: :club, rank: :king}) ==
      %Card{suit: :club, rank: :king}
  end

  test "aces are higher rank than kings" do
    assert CardGameWar.get_higher(%Card{suit: :spades, rank: :ace}, %Card{suit: :club, rank: :king}) ==
      %Card{suit: :spades, rank: :ace}
  end
  
  test "if the ranks are equal, clubs beat spades" do
    assert CardGameWar.get_higher(%Card{suit: :club, rank: 8}, %Card{suit: :spade, rank: 8}) ==
      %Card{suit: :club, rank: 8}

  end

  test "if the ranks are equal, diamonds beat clubs" do
    assert CardGameWar.get_higher(%Card{suit: :club, rank: :jack}, %Card{suit: :diamond, rank: :jack}) ==
      %Card{suit: :diamond, rank: :jack}

  end

  test "if the ranks are equal, hearts beat diamonds" do
    assert CardGameWar.get_higher(%Card{suit: :heart, rank: 8}, %Card{suit: :diamond, rank: 8}) ==
      %Card{suit: :heart, rank: 8}
  end

  test "the player loses when they run out of cards" do
    assert CardGameWar.play(52, 0, :deck_player_1, :deck_player_2) == "Player 1 wins"
    assert CardGameWar.play(0, 52, :deck_player_1, :deck_player_2) == "Player 2 wins"
  end

end
