require File.expand_path("../../rora_test", File.dirname(__FILE__))

class PlayerTest < ActiveSupport::TestCase

  def setup
    @game = Game.new
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

  test "a player should be able to join a poker game" do
    @player.join_game @game
    assert_equal @player, @game.table.seat[0].player
  end

  test "a player should be able to join a poker game at a seat of their choosing" do
    @player.join_game @game, 3
    assert_equal @player, @game.table.seat[2].player
  end

  test "a player should not be able to join a poker game when the poker table is full" do
    @game.table.stub(:full?).and_return(true)
    assert_raise_message "Frank cannot join this game, the table is full", ArgumentError do
      @player.join_game @game
    end
  end

  test "a player should not be able to join more than one game" do
    @player.join_game @game
    assert_raise_message "Frank cannot join this game, this player is already playing another game", ArgumentError do
      @player.join_game @game
    end
  end

  test "a player should not be able to start a session at a table if they do not have a seat at the table" do
    assert_raise_message "Frank is not sitting at a table", ArgumentError do
      @player.start_session
    end
  end

  test "a player should be able to start a session at the poker table" do
    @player.join_game @game
    @player.start_session
    assert_equal false, @player.sitting_out?
  end

  test "a player should be able to leave a game" do
    @player.join_game @game
    @player.start_session
    @player.leave_game
    assert_equal nil, @player.game
  end

  test "a player should not be able to post a small blind if the player has not joined a game" do
    assert_raise_message "Frank has not joined a game, cannot post the small blind", ArgumentError do
      @player.post_small_blind
    end
  end

  test "a player should not be able to post a big blind if the player has not joined a game" do
    assert_raise_message "Frank has not joined a game, cannot post the big blind", ArgumentError do
      @player.post_big_blind
    end
  end

  test "a player should not be able to post a small blind if the player is sitting out" do
    @player.join_game @game
    assert_raise_message "Frank is sitting out, cannot post the small blind", ArgumentError do
      @player.post_small_blind
    end
  end

  test "a player should not be able to post a big blind if the player is sitting out" do
    @player.join_game @game
    assert_raise_message "Frank is sitting out, cannot post the big blind", ArgumentError do
      @player.post_big_blind
    end
  end

  test "a player should be able to post a small blind" do
    @player.join_game @game
    @player.start_session
    @player.post_small_blind
    assert_equal 0.25, @game.pot.value
  end

  test "a player should be able to post a big blind" do
    @player.join_game @game
    @player.start_session
    @player.post_big_blind
    assert_equal 0.50, @game.pot.value
  end

end
