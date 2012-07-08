require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandTest < ActiveSupport::TestCase

  def setup
    @hand = Hand.new("AS,KS,QS,JS,TS")
  end

  test "should raise an error when a hand is not created with 5 cards" do
    assert_raise_message "Exactly 5 cards are required to create a hand, 2 provided", ArgumentError do
      Hand.new [Card.new("AS"), Card.new("KS")]
    end
  end

  test "should raise an error when a hand is not created with 10 characters" do
    assert_raise_message "Exactly 5 cards are required to create a hand, 8 provided", ArgumentError do
      Hand.new "ASKSQSJS"
    end
  end

  test "should raise an error when creating a hand with duplicate cards" do
    assert_raise_message "The hand contains duplicate cards", ArgumentError do
      Hand.new "AS KS JS AS KS"
    end
  end

  test "the hand should have an id" do
    assert_equal 7193866898674063, @hand.id
  end

  test "the hand id should be equal to the product of each card id contained in the hand" do
    assert_equal @hand.id, (Card.new("AS").id * Card.new("KS").id * Card.new("QS").id * Card.new("JS").id * Card.new("TS").id)
  end

  test "the hand should have a hash key" do
    assert_equal 2101589603, @hand.hash_key
  end

  test "the hash key should be equal to the product of each card rank id in the hand times" do
    assert_equal Hand.new("ASACAHJSTS").hash_key, (Card.new("AS").rank.id * Card.new("AC").rank.id * Card.new("AH").rank.id * Card.new("JS").rank.id * Card.new("TS").rank.id)
  end

  test "the hash key should be equal to the product of each card rank id in the hand times 67 when the hand is a flush" do
    assert_equal @hand.hash_key, (Card.new("AS").rank.id * Card.new("KS").rank.id * Card.new("QS").rank.id * Card.new("JS").rank.id * Card.new("TS").rank.id * 67)
  end

  test "the hand should have a value" do
    assert_equal "AS,KS,QS,JS,TS", @hand.value
  end

  test "the hand should be a flush" do
    assert_equal true, @hand.flush?
  end

  test "the hand should not be a flush" do
    assert_equal false, Hand.new("2D3S4H8CJS").flush?
  end

  test "the hand should have a score" do
    assert_equal 1, @hand.score
  end

  test "the hand should have a probability" do
    assert_equal 0.0015, @hand.probability
  end

  test "the hand should have a name" do
    assert_equal "Royal Flush", @hand.name
  end

  test "the hand should have a hand type" do
    assert_equal HandType::STRAIGHT_FLUSH, @hand.type
  end

  test "the hand should have five cards" do
    assert_equal 5, @hand.cards.size
  end

  test "the hand should be a straight flush" do
    assert_equal true, @hand.straight_flush?
  end

  test "the hand should be a straight" do
    assert_equal true, Hand.new("ACKSQSJDTS").straight?
  end

  test "the hand should be a four of a kind" do
    assert_equal true, Hand.new("ACASAHADJS").four_of_a_kind?
  end

end
