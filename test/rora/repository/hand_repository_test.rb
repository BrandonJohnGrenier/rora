require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandRepositoyTest < ActiveSupport::TestCase
  
  def setup
    @repository = HandRepository.instance
  end

  test "should be able to evaluate a 5 card poker hand" do
    result =  @repository.evaluate_5_card_hand Card.to_cards("AS,KS,QS,JS,TS")
    assert_equal 1, result[0]
    assert_equal "SF", result[1]
    assert_equal "Royal Flush", result[2]
  end

  test "should be able to evaluate a 7 card poker hand" do
    result = @repository.evaluate_7_card_hand Card.to_cards("KS,3H,2S,AS,AC,AH,AD")
    assert_equal 11, result[0]
  end

  test "should return all 2,598,960 poker hands" do
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
    assert_equal 7462, @repository.list_and_group_by_hand_score.size
  end

  test "should return every distinct poker hand that can be made with the given starting hand" do
    assert_equal 620, @repository.list_and_group_by_hand_score(:starting_hand => StartingHand.new("AS,KS")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand and deck" do
    deck = Deck.new.remove "AH,KH,AD,KD"
    assert_equal 594, @repository.list_and_group_by_hand_score(:starting_hand => StartingHand.new("AS,KS"), :deck => deck).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand, flop, turn and river" do
    assert_equal 21, @repository.list_and_group_by_hand_score(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS,4H,3H")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand, flop and turn" do
    assert_equal 212, @repository.list_and_group_by_hand_score(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS,4H")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand and flop" do
    assert_equal 1042, @repository.list_and_group_by_hand_score(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS")).size
  end

  test "should return every distinct poker hand that can be made with the given starting hand, flop and deck" do
    deck = Deck.new.remove "AH,KH,AD,KD"
    assert_equal 1030, @repository.list_and_group_by_hand_score(:starting_hand => StartingHand.new("AS,KS"), :board => Board.new("QS,JS,TS"), :deck => deck).size
  end

end
