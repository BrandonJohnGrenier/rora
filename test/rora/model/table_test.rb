require File.expand_path("../../rora_test", File.dirname(__FILE__))

class TableTest < ActiveSupport::TestCase

  def setup
    @table = Table.new
  end

  test "a table should have 9 seats by default" do
    assert_equal 9, @table.seats.size
  end

  test "a new table should have a deck of 52 cards" do
    assert_equal 52, @table.deck.size
  end

  test "a new table should have an empty board" do
    assert_equal 0, @table.board.cards.size
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
    assert_equal 6, Table.new(6).seats.size
  end

  test "should raise an error when a table is created with less than two seats" do
    assert_raise ArgumentError do
      Table.new 1
    end
  end

  test "should be able to seat a player at the table" do
    @table.add "player"
    assert_equal "player", @table.seats[0]
  end

  test "should be able to seat a player at a specific seat at the table" do
    @table.add "player", 4
    assert_equal "player", @table.seats[3]
  end

  test "should raise an error when attempting to seat a player at a seat that is already taken" do
    @table.add "player1", 4
    assert_raise ArgumentError do
      @table.add "player2", 4
    end
  end

  test "should raise an error when attempting to seat a player at a seat that does not exist" do
    assert_raise ArgumentError do
      @table.add "player", 11
    end
    assert_raise ArgumentError do
      @table.add "player", 0
    end
    assert_raise ArgumentError do
      @table.add "player", -3
    end
  end

  test "should find the first available seat when no seat number is specified" do
    @table.add("player1", 1).add("player2", 2).add("player 3", 3).add("player5", 5)
    @table.add "player4"
    assert_equal @table.seats[3], "player4"
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
    assert_not_nil @table.seats[0]
    @table.remove "player1"
    assert_nil @table.seats[0]
  end

end
