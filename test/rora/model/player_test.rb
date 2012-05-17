require File.expand_path("../../rora_test", File.dirname(__FILE__))

class PlayerTest < ActiveSupport::TestCase

  def setup
    @table = Table.new
    @player = Player.new "Frank", 100000
    RSpec::Mocks::setup(self)
  end

  test "the player should have a name" do
    assert_equal "foo", Player.new.with_name("foo").name
  end

  test "the player should have a bankroll" do
    assert_equal 1000, Player.new.with_funds(1000).funds
  end

  test "a player should be able to join a poker table" do
    @player.join @table
    assert_equal @player, @table.seat[0].player
  end

  test "a player should be able to join a poker table at a seat of their choosing" do
    @player.join @table, 3
    assert_equal @player, @table.seat[2].player
  end

  test "a player should not be able to join a poker table when the table is full" do
    @table.stub(:full?).and_return(true)
    assert_raise ArgumentError do
      @player.join @table
    end
  end

  test "a player should not be able to join a table they have already joined" do
    @player.join @table
    assert_raise_message "Frank is already sitting at this table", ArgumentError do
      @player.join @table
    end
  end

  test "a player should not be able to start a session at a table if they do not have a seat at the table" do
    assert_raise_message "Frank is not sitting at this table", ArgumentError do
      @player.start_session @table, 1000
    end
  end

  test "a player should not be able to start a session if their stack for the session exceeds available funds" do
    @player.join @table
    assert_raise_message "Frank cannot start with a $500000 stack, as it exceeds available funds: $100000", ArgumentError do
      @player.start_session @table, 500000
    end
  end

  test "a player should be able to start a session at the poker table" do
    @player.join @table
    @player.start_session @table, 1000
  end

end
