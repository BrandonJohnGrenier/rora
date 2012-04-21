require File.expand_path("../../rora_test", File.dirname(__FILE__))

class CardTest < ActiveSupport::TestCase

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

  test "should raise an exception when attempting to create a card with an invalid string value" do
    assert_raise ArgumentError do
      card = Card.new("A")
    end
  end

  test "a card id should be equal to the product of the card suit id and rank id" do
    card = Card.new(Rank::ACE, Suit::SPADE)
    assert_equal card.id, (Rank::ACE.id * Suit::SPADE.id)
  end

  test "a card value should be equal to the concatenation of the card suit value and rank value" do
    card = Card.new(Rank::ACE, Suit::SPADE)
    assert_equal card.value, (Rank::ACE.value + Suit::SPADE.value)
  end

  test "a card key should be equal to the concatenation of the card suit key and rank key" do
    assert_equal "AS", Card.new("AS").key
  end

  test "a card should have a name" do
    assert_equal "Ace of Spades", Card.new("AS").name
  end

  test "should generate a readable string representation" do
    assert_equal "Card: name='Ace of Spades' value='AS' id=1927", Card.new("AS").to_s
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
