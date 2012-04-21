require File.expand_path("../../rora_test", File.dirname(__FILE__))

class BoardTest < ActiveSupport::TestCase

  test "should raise an error when a board is created with less than 3 cards" do
    assert_raise ArgumentError do
      Board.new "AS,KS"
    end
  end

  test "should raise an error when a board is created with more than 5 cards" do
    assert_raise ArgumentError do
      Board.new "AS,KS,QS,JS,TS,9S"
    end
  end

  test "should raise an error when a board is created with duplicate cards" do
    assert_raise ArgumentError do
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
    assert_raise ArgumentError do
      Board.new.flop "AS,KS"
    end
  end

  test "should raise an error when a flop is set with duplicate cards" do
    assert_raise ArgumentError do
      Board.new.flop "AS AS JS"
    end
  end

  test "should raise an error when a flop is set with no cards" do
    assert_raise ArgumentError do
      Board.new.flop []
    end
  end

  test "should have a board with three cards after the flop is dealt" do
    board = Board.new
    board.flop = "AS KS QS"
    assert_equal 3, board.cards.size
    assert_equal board.flop, board.cards
  end

  test "should raise an error when a turn card is dealt before the flop has been dealt" do
    assert_raise RuntimeError do
      board = Board.new
      board.turn = "AS"
    end
  end

  test "should raise an error when the turn card has already been dealt" do
    assert_raise ArgumentError do
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
    assert_raise RuntimeError do
      board = Board.new
      board.flop = "AS KS QS"
      board.river = "JS"
    end
  end

  test "should raise an error when the river card has already been dealt" do
    assert_raise ArgumentError do
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

  test "should return false if the board does not contain any of the given cards" do
    board = Board.new "AS,KS,QS,JS,TS"
    assert_equal false, board.contains_any?(Card.to_cards("AH,KH,QH"))
  end

  test "should return true if the board contains at least one of the given cards" do
    board = Board.new "AS,KS,QS,JS,TS"
    assert_equal true, board.contains_any?(Card.to_cards("AH,KH,QH,JH,KS"))
  end

end
