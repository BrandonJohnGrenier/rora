require File.expand_path("../../rora_test", File.dirname(__FILE__))

class BoardTest < ActiveSupport::TestCase

  def setup
    @board = Board.new "AS,KS,QS,JS,TS"
  end

  test "should raise an error when a board is created with less than 3 cards" do
    assert_raise_message "3 to 5 cards are required to create a board, 2 cards provided", ArgumentError do
      Board.new "AS,KS"
    end
  end

  test "should raise an error when a board is created with more than 5 cards" do
    assert_raise_message "3 to 5 cards are required to create a board, 6 cards provided", ArgumentError do
      Board.new "AS,KS,QS,JS,TS,9S"
    end
  end

  test "should raise an error when a board is created with duplicate cards" do
    assert_raise_message "The board contains duplicate cards", ArgumentError do
      Board.new "AS KS JS AS KS"
    end
  end

  test "should have an empty board if the board was not initialized with cards" do
    assert_equal 0, Board.new.cards.size
  end

  test "the board should have three cards if the board was initialized with the flop" do
    assert_equal 3, Board.new("AS,KS,QS").cards.size
  end

  test "the board should have four cards if the board was initialized with the flop and turn" do
    assert_equal 4, Board.new("AS,KS,QS,JS").cards.size
  end

  test "the board should have five cards if the board was initialized with the flop, turn and river" do
    assert_equal 5, Board.new("AS,KS,QS,JS,TS").cards.size
  end

  test "should raise an error when a flop is not created with 3 cards" do
    assert_raise_message "3 cards are required on the flop, 2 cards provided", ArgumentError do
      Board.new.flop= "AS,KS"
    end
  end

  test "should raise an error when a flop is set with duplicate cards" do
    assert_raise_message "The flop contains duplicate cards", ArgumentError do
      Board.new.flop= "AS AS JS"
    end
  end

  test "should raise an error when a flop is set with no cards" do
    assert_raise_message "Cannot deal a flop with empty array of cards", ArgumentError do
      Board.new.flop= []
    end
  end

  test "should have a board with three cards after the flop is dealt" do
    board = Board.new
    board.flop = "AS KS QS"
    assert_equal 3, board.cards.size
    assert_equal board.flop, board.cards
  end

  test "should raise an error when a turn card is dealt before the flop has been dealt" do
    assert_raise_message "The flop must be dealt before the turn card is dealt", RuntimeError do
      board = Board.new
      board.turn = "AS"
    end
  end

  test "should raise an error when the turn card has already been dealt on the flop" do
    assert_raise_message "The board already contains the Ace of Hearts", ArgumentError do
      board = Board.new
      board.flop= "AS,AH,AD"
      board.turn= "AH"
    end
  end

  test "should have a board with four cards after the turn card is dealt" do
    board = Board.new
    board.flop = "AS KS QS"
    board.turn = "JS"
    assert_equal 4, board.cards.size
    assert_equal Card.new("JS"), board.turn
  end

  test "should raise an error when the river card is dealt before the turn card has been dealt" do
    assert_raise_message "The turn card must be dealt before the river card is dealt", RuntimeError do
      board = Board.new
      board.flop = "AS KS QS"
      board.river = "JS"
    end
  end

  test "should raise an error when the river card was dealt on a previous street" do
    assert_raise_message "The board already contains the Ace of Spades", ArgumentError do
      board = Board.new
      board.flop = "AS,KS,QS"
      board.turn = "JS"
      board.river = "AS"
    end
  end

  test "should have a board with five cards after the river card is dealt" do
    board = Board.new
    board.flop = "AS KS QS"
    board.turn = "JS"
    board.river = "TS"
    assert_equal 5, board.cards.size
    assert_equal Card.new("TS"), board.river
  end

  test "should return false if the board does not contain the given card" do
    assert_equal false, @board.contains?("3D")
    assert_equal false, @board.contains?(Card.new("3D"))
  end

  test "should return true if the boad does contain the given card" do
    assert_equal true, @board.contains?("TS")
    assert_equal true, @board.contains?(Card.new("AS"))
  end

  test "should return false if the board does not contain any of the given cards" do
    assert_equal false, @board.contains_any?(Card.to_cards("AH,KH,QH"))
    assert_equal false, @board.contains_any?("AH,KH,QH")
  end

  test "should return true if the board contains at least one of the given cards" do
    assert_equal true, @board.contains_any?(Card.to_cards("AH,KH,QH,JH,KS"))
    assert_equal true, @board.contains_any?("AH,KH,QH,JH,KS")
  end

end
