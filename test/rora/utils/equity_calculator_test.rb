require File.expand_path("../../rora_test", File.dirname(__FILE__))

class EquityCalculatorTest < ActiveSupport::TestCase
  
  def setup
    @board = Board.new
    @calculator = EquityCalculator.new
  end

#  test "should return equity calculations for a heads up game" do
#    starting_hands = [StartingHand.new("2H2S"), StartingHand.new("3H3S")]
#
#    equities = @calculator.calculate_equity(starting_hands, @board)
#
#    assert_equity_value "6.77", "2H2S", equities
#    assert_equity_value "86.77", "3H3S", equities
#  end

  test "should find the best 5-card hand from 7 cards" do
    best_hand = @calculator.find_best_5_card_hand Card.to_cards("AS,AH,AC,AD,2S,2C,2H")
    assert_equal "ASAHACAD2S", best_hand.key
  end

  test "should raise an error when there are no starting hands to compare" do
    starting_hands = []
    assert_raise_message "Must have at least two starting hands for equity comparison", ArgumentError do
      @calculator.calculate_equity(starting_hands, Board.new)
    end
  end

  test "should raise an error when there is only one starting hand to compare" do
    starting_hands = [StartingHand.new("2H2S")]
    assert_raise_message "Must have at least two starting hands for equity comparison", ArgumentError do
      @calculator.calculate_equity(starting_hands, Board.new)
    end
  end

  test "should raise an error when there there are duplicate cards across starting hands" do
    starting_hands = [StartingHand.new("2H2S"), StartingHand.new("5H6H"), StartingHand.new("3S2S")]
    assert_raise_message "There are duplicate cards", ArgumentError do
      @calculator.calculate_equity(starting_hands, @board)
    end
  end

  test "should raise an error when there there are duplicate cards on the board" do
    starting_hands = [StartingHand.new("ASKD"), StartingHand.new("5H6H"), StartingHand.new("3D2D")]
    assert_raise_message "There are duplicate cards", ArgumentError do
      @calculator.calculate_equity(starting_hands, Board.new("AS2D7C"))
    end
  end

  def assert_equity_value value, starting_hand, equities
    assert_equal value, sprintf("%.02f", equities[StartingHand.new(starting_hand)].value)
  end

end
