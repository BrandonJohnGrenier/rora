require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandTest < ActiveSupport::TestCase

  def setup
    @hand = Hand.new("ASKSQSJSTS")
  end

  test "a hand should have an id" do
    assert_equal 7193866898674063, @hand.id
  end

  test "an id should be equal to the product of each card id contained in the hand" do
    assert_equal @hand.id, (Card.new("AS").id * Card.new("KS").id * Card.new("QS").id * Card.new("JS").id * Card.new("TS").id)
  end

  test "a hand should have a hash key" do
    assert_equal 2101589603, @hand.hash_key
  end

  test "a hash key should be equal to the product of each card suit id in the hand" do
    
  end

end
