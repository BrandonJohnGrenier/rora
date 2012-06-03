require File.expand_path("../../rora_test", File.dirname(__FILE__))

class TableTest < ActiveSupport::TestCase

  def setup
    @table = Table.new
  end

  test "a table should have 9 seats by default" do
    assert_equal 9, @table.size
  end

  test "a new table should have a deck of 52 cards" do
    assert_equal 52, @table.deck.size
  end

  test "a new table should have an empty board" do
    assert_equal 0, @table.board.size
  end

  test "a new table should have a pot with no money" do
    assert_equal 0, @table.pot.value
  end

  test "should be able to reset a board" do
    @table.with(Deck.new.remove("AS,KS,QS")).with(Board.new("AH,KH,QH")).with(Pot.new.add(50))
    assert_equal 50, @table.pot.value
    assert_equal 3, @table.board.cards.size
    assert_equal 49, @table.deck.size

    @table.reset
    assert_equal 0, @table.pot.value
    assert_equal 0, @table.board.cards.size
    assert_equal 52, @table.deck.size
  end

  test "should be able to configure the number of seats at a table" do
    assert_equal 6, Table.new(6).size
  end

  test "should raise an error when a table is created with less than two seats" do
    assert_raise ArgumentError, "A table must have at least two seats" do
      Table.new 1
    end
  end

  test "should be able to seat a player at the table" do
    @table.add "player"
    assert_equal "player", @table.seat[0].player
  end

  test "should be able to seat a player at a specific seat at the table" do
    @table.add "player", 4
    assert_equal "player", @table.seat[3].player
  end

  test "should raise an error when attempting to seat a player at a seat that is already taken" do
    @table.add "player1", 4
    assert_raise ArgumentError, "Seat number 4 is already taken by another player" do
      @table.add "player2", 4
    end
  end

  test "should raise an error when attempting to seat a player at a seat that does not exist" do
    assert_raise ArgumentError, "Seat number 11 does not exist at this table" do
      @table.add "player", 11
    end
    assert_raise ArgumentError, "Seat number 0 does not exist at this table"  do
      @table.add "player", 0
    end
    assert_raise ArgumentError, "Seat number -3 does not exist at this table"  do
      @table.add "player", -3
    end
  end

  test "should find the first available seat when no seat number is specified" do
    @table.add("Player 1", 1).add("Player 2", 2).add("Player 3", 3).add("Player 5", 5)
    @table.add "Player 4"
    assert_equal @table.seat[3].player, "Player 4"
  end

  test "full? should return true when the table is full" do
    (1..9).each {|x| @table.add("player#{x}")}
    assert_equal true, @table.full?
  end

  test "full? should return false when the table is not full" do
    (1..8).each {|x| @table.add("player#{x}")}
    assert_equal false, @table.full?
  end

  test "empty? should return true when the table is empty" do
    assert_equal true, @table.empty?
  end

  test "empty? should return false when the table is not empty" do
    @table.add "player"
    assert_equal false, @table.empty?
  end

  test "should raise an error when attempting to seat a player at a full table" do
    (1..9).each {|x| @table.add("player#{x}")}
    assert_raise RuntimeError do
      @table.add "player 10"
    end
  end

  test "should be able to remove a player" do
    @table.add "player1"
    assert_equal true,  @table.seat[0].taken?
    @table.remove "player1"
    assert_equal false, @table.seat[0].taken?
  end

  test "should return the next player to act after the specified seat" do
    @table.add("Player 1", 1).add("Player 5", 5)
    seat = @table.next_player @table.seat[0]
    assert_equal "Player 5", seat.player
  end

  test "should return the next player to act even when the specified seat is empty" do
    @table.add("Player 1", 1).add("Player 5", 5)
    seat = @table.next_player @table.seat[3]
    assert_equal "Player 5", seat.player
  end

  test "should loop around the table to find the next player to act" do
    @table.add("Player 1", 1).add("Player 5", 5)
    seat = @table.next_player @table.seat[7]
    assert_equal "Player 1", seat.player
  end

  test "should raise an error when trying to find the next player to act when there are less than two players at the table" do
    @table.add("Player 1", 1)
    assert_raise RuntimeError, "Cannot find the next player when there are less than two players at the table" do
      @table.next_player @table.seat[7]
    end
  end

  test "should return the previous player to act before the specified seat" do
    @table.add("Player 1", 1).add("Player 5", 5)
    seat = @table.previous_player @table.seat[4]
    assert_equal "Player 1", seat.player
  end

  test "should return the previous player to act even when the specified seat is empty" do
    @table.add("Player 1", 1).add("Player 5", 5)
    seat = @table.previous_player @table.seat[3]
    assert_equal "Player 1", seat.player
  end

  test "should loop around the table to find the previous player to act" do
    @table.add("Player 1", 3).add("Player 5", 5)
    seat = @table.previous_player @table.seat[1]
    assert_equal "Player 5", seat.player
  end

  test "should raise an error when trying to find the previous player to act when there are less than two players at the table" do
    @table.add("Player 1", 1)
    assert_raise RuntimeError, "Cannot find the previous player when there are less than two players at the table" do
      @table.previous_player @table.seat[7]
    end
  end

  test "should return the seat holding the button" do
    @table.add("Player 1", 1).add("Player 2", 2).add("Player 3", 3).add("Player 5", 5)
    @table.seat[4].button = true
    assert_equal "Player 5", @table.find_button.player
  end

  test "should return the first seat occupied by a player if no seat is holding the button" do
    @table.add("Player 1", 1).add("Player 2", 2).add("Player 3", 3).add("Player 5", 5)
    assert_equal "Player 1", @table.find_button.player
  end

  test "should pass the buck to players in clockwise order" do
    @table.add("Player 1", 1).add("Player 2", 2).add("Player 3", 3).add("Player 5", 5).add("Player 7", 7)
    
    @table.pass_the_buck
    assert_equal "Player 2", @table.find_button.player
    
    @table.pass_the_buck
    assert_equal "Player 3", @table.find_button.player
    
    @table.pass_the_buck
    assert_equal "Player 5", @table.find_button.player
    
    @table.pass_the_buck
    assert_equal "Player 7", @table.find_button.player
    
    @table.pass_the_buck
    assert_equal "Player 1", @table.find_button.player
    
    @table.pass_the_buck
    assert_equal "Player 2", @table.find_button.player
  end
  
end
