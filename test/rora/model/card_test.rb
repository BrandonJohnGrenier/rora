require File.expand_path("../../rora_test", File.dirname(__FILE__))

class CardTest < ActiveSupport::TestCase
  def setup
    @card = Card.new("AS")
  end

  test "should be able to sort cards by rank" do
    cards = Card.to_cards "2H,4D,QS,JC,7D,TC,AH,KD,6H,9D,3S,5C,8C"
    cards.sort!

    assert_equal "Ace of Hearts", cards[0].value
    assert_equal "King of Diamonds", cards[1].value
    assert_equal "Queen of Spades", cards[2].value
    assert_equal "Jack of Clubs", cards[3].value
    assert_equal "Ten of Clubs", cards[4].value
    assert_equal "Nine of Diamonds", cards[5].value
    assert_equal "Eight of Clubs", cards[6].value
    assert_equal "Seven of Diamonds", cards[7].value
    assert_equal "Six of Hearts", cards[8].value
    assert_equal "Five of Clubs", cards[9].value
    assert_equal "Four of Diamonds", cards[10].value
    assert_equal "Three of Spades", cards[11].value
    assert_equal "Two of Hearts", cards[12].value
  end

  test "should be able to sort cards by suit" do
    cards = Card.to_cards "AS,AH,AD,AC"
    cards.sort!

    assert_equal "Ace of Hearts", cards[0].value
    assert_equal "Ace of Diamonds", cards[1].value
    assert_equal "Ace of Spades", cards[2].value
    assert_equal "Ace of Clubs", cards[3].value

  end

  test "should be able to identify duplicate cards" do
    cards = Card.to_cards("AS,AS,KS,KS")
    assert_equal 2, cards.uniq.size
  end

  test "should be able to create a card with the specified rank and suit" do
    card = Card.new(Rank::ACE, Suit::SPADE)
    assert_equal card.rank, Rank::ACE
    assert_equal card.suit, Suit::SPADE
  end

  test "should be able to create a card with the specified string value" do
    card = Card.new("AS")
    assert_equal card.rank, Rank::ACE
    assert_equal card.suit, Suit::SPADE
  end

  test "should have an id" do
    assert_equal 103, @card.id
  end

  test "should raise an exception when attempting to create a card with an invalid string value" do
    assert_raise_message "A is an invalid card sequence", ArgumentError do
      card = Card.new("A")
    end
    assert_raise_message "ASK is an invalid card sequence", ArgumentError do
      card = Card.new("ASK")
    end
  end

  test "a card should have a key" do
    assert_equal "AS", @card.key
  end

  test "a card key should be equal to the concatenation of the cards' suit key and rank key" do
    assert_equal "AS", (Rank::ACE.key + Suit::SPADE.key)
  end

  test "a card should have a value" do
    assert_equal "Ace of Spades", Card.new("AS").value
  end

  test "should generate a readable string representation" do
    assert_equal "Ace of Spades", Card.new("AS").to_s
  end

  test "should convert an arbitrarily long string of characters into an array of cards" do
    assert_equal 7, Card.to_cards("ASKSJSQSTCJCAH").size
  end

  test "should convert an arbitrarily long string of comma-delimited characters into an array of cards" do
    assert_equal 7, Card.to_cards("AS,KS,JS,QS,TC,JC,AH").size
  end

  test "should convert an arbitrarily long string of space-delimited characters into an array of cards" do
    assert_equal 7, Card.to_cards("AS KS JS QS TC JC AH").size
  end

end
