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
    assert_equal 19600, @repository.list(:starting_hand => StartingHand.new("AS,KS")).size
  end

  test "should return every poker hand that can be made with the given starting hand and deck" do
    deck = Deck.new.remove "AH,KH,AD,KD"
    assert_equal 15180, @repository.list(:starting_hand => StartingHand.new("AS,KS"), :deck => deck).size
  end

  test "should return every poker hand that can be made with the given starting hand, flop, turn and river" do
    assert_equal 21, @repository.list(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS,4H,3H")).size
  end

  test "should return every poker hand that can be made with the given starting hand, flop and turn" do
    assert_equal 966, @repository.list(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS,4H")).size
  end

  test "should return every poker hand that can be made with the given starting hand and flop" do
    assert_equal 22701, @repository.list(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS")).size
  end

  test "should return every poker hand that can be made with the given starting hand, flop and deck" do
    deck = Deck.new.remove "AH,KH,AD,KD"
    assert_equal 18963, @repository.list(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS"), :deck => deck).size
  end

  test "should return every distinct poker hand" do
    assert_equal 7462, @repository.list_unique.size
  end

  test "should return every distinct poker hand that can be made with the given starting hand" do
    assert_equal 620, @repository.list_unique(:starting_hand => StartingHand.new("AS,KS")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand and deck" do
    deck = Deck.new.remove "AH,KH,AD,KD"
    assert_equal 594, @repository.list_unique(:starting_hand => StartingHand.new("AS,KS"), :deck => deck).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand, flop, turn and river" do
    assert_equal 21, @repository.list_unique(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS,4H,3H")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand, flop and turn" do
    assert_equal 212, @repository.list_unique(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS,4H")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand and flop" do
    assert_equal 1042, @repository.list_unique(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand, flop and deck" do
    deck = Deck.new.remove "AH,KH,AD,KD"
    assert_equal 1030, @repository.list_unique(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS"), :deck => deck).size
  end

end
