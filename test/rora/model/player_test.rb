require File.expand_path("../../rora_test", File.dirname(__FILE__))

class PlayerTest < ActiveSupport::TestCase

  def setup
    @table = Table.new
    @player = Player.new "Frank", 100000
    RSpec::Mocks::setup(self)
  end

  test "a player should have a name" do
    assert_equal "foo", Player.new("foo", 999).name
  end

  test "a player should have a stack" do
    assert_equal 1000, Player.new("feff", 1000).stack
  end

  test "should raise an error if the player name is nil" do
    assert_raise_message "The player name cannot be nil", ArgumentError do
      Player.new nil, 2000
    end
  end

  test "a player should be able to join a poker table" do
    @player.join_table @table
    assert_equal @player, @table.seat[0].player
  end

  test "a player should be able to join a poker table at a seat of their choosing" do
    @player.join_table @table, 3
    assert_equal @player, @table.seat[2].player
  end

  test "a player should not be able to join a poker table when the table is full" do
    @table.stub(:full?).and_return(true)
    assert_raise_message "This table is full", ArgumentError do
      @player.join_table @table
    end
  end

  test "a player should not be able to join a table they have already joined" do
    @player.join_table @table
    assert_raise_message "Frank is already sitting at a table", ArgumentError do
      @player.join_table @table
    end
  end

  test "a player should not be able to start a session at a table if they do not have a seat at the table" do
    assert_raise_message "Frank is not sitting at a table", ArgumentError do
      @player.start_session
    end
  end

  test "a player should be able to start a session at the poker table" do
    @player.join_table @table
    @player.start_session
    assert_equal false, @player.sitting_out?
  end

  test "a player should be able to leave a table" do
    @player.join_table @table
    @player.start_session
    @player.leave_table
    assert_equal nil, @player.table
  end

end
