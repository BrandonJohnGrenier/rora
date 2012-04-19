require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandRepositoyTest < ActiveSupport::TestCase

  def setup
    @repository = HandRepository.instance
  end

  test "should be able to find a poker hand by id" do
    result =  @repository.find 2101589603
    assert_equal 1, result[0]
    assert_equal "SF", result[1]
    assert_equal "Royal Flush", result[2]
    assert_equal 0.0015, result[3]
  end

  test "should raise an error when attempting to find a poker hand with an invalid id" do
    assert_raise KeyError do
      @repository.find 210158960345
    end
  end

  test "should return every poker hand" do
    assert_equal 2598960, @repository.list.size
  end

  test "should return every poker hand that can be made with the given starting hand" do
    assert_equal 19600, @repository.list(StartingHand.new("ASKS")).size
  end

  test "should return every poker hand that can be made with the given starting hand and deck" do
    deck = Deck.new.remove(Card.new("AH")).remove(Card.new("KH")).remove(Card.new("AD")).remove(Card.new("KD"))
    assert_equal 15180, @repository.list(StartingHand.new("ASKS"), deck).size
  end

end
