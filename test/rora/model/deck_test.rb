require File.expand_path("../../rora_test", File.dirname(__FILE__))

class DeckTest < ActiveSupport::TestCase

  def setup
    @deck = Deck.new
    @card = Card.new("AS")
  end

  test "a deck should contain 52 cards" do
    assert_equal 52, @deck.size
  end

  test "a deck should not be empty" do
    assert_equal false, @deck.empty?
  end

  test "a deck should be empty after all 52 cards have been dealt" do
    52.times { @deck.deal }
    assert_equal true, @deck.empty?
  end

  test "a deck should contain 4 cards of each rank" do
    assert_equal 4, @deck.count_cards_with_rank(Rank::ACE)
    assert_equal 4, @deck.count_cards_with_rank(Rank::KING)
    assert_equal 4, @deck.count_cards_with_rank(Rank::QUEEN)
    assert_equal 4, @deck.count_cards_with_rank(Rank::JACK)
    assert_equal 4, @deck.count_cards_with_rank(Rank::TEN)
    assert_equal 4, @deck.count_cards_with_rank(Rank::NINE)
    assert_equal 4, @deck.count_cards_with_rank(Rank::EIGHT)
    assert_equal 4, @deck.count_cards_with_rank(Rank::SEVEN)
    assert_equal 4, @deck.count_cards_with_rank(Rank::SIX)
    assert_equal 4, @deck.count_cards_with_rank(Rank::FIVE)
    assert_equal 4, @deck.count_cards_with_rank(Rank::FOUR)
    assert_equal 4, @deck.count_cards_with_rank(Rank::THREE)
    assert_equal 4, @deck.count_cards_with_rank(Rank::TWO)
  end

  test "a deck should contain 13 cards of each suit" do
    assert_equal 13, @deck.count_cards_with_suit(Suit::CLUB)
    assert_equal 13, @deck.count_cards_with_suit(Suit::DIAMOND)
    assert_equal 13, @deck.count_cards_with_suit(Suit::HEART)
    assert_equal 13, @deck.count_cards_with_suit(Suit::SPADE)
  end

  test "should return a shallow copy of cards" do
    assert_equal 52, @deck.size
    @deck.cards.delete_at(0)
    assert_equal 52, @deck.size
  end

  test "should shuffle the cards in a deck" do
    before = @deck.cards[0]
    @deck.shuffle
    after = @deck.cards[0]
    assert_not_equal before, after
  end

  test "should remove a card from the deck" do
    assert_equal 52, @deck.size
    @deck.remove @card
    assert_equal 51, @deck.size
    @deck.remove @card
    assert_equal 51, @deck.size
  end

  test "should remove multiple cards from the deck" do
    cards = [Card.new("QS"), Card.new("KS"), Card.new("AS")]

    assert_equal 52, @deck.size
    @deck.remove cards
    assert_equal 49, @deck.size
    @deck.remove cards
    assert_equal 49, @deck.size
  end

  test "should remove a starting hand from the deck" do
    assert_equal 52, @deck.size
    @deck.remove StartingHand.new("ASKS")
    assert_equal 50, @deck.size
  end

  test "should determine if the given card is in the deck" do
    assert_equal true, @deck.contains(@card)
    @deck.remove(@card)
    assert_equal false, @deck.contains(@card)
  end

  test "should deal a card from the deck" do
    card = @deck.deal
    assert_not_nil card
    assert_equal 51, @deck.size
  end

end
