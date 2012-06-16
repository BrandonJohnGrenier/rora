#
# A player in a Texas Hold'em game.
#
class Player
  attr_reader :name, :stack, :game

  def initialize name, stack
    raise ArgumentError, "The player name cannot be nil" if name.nil?
    @name = name
    @stack = stack.nil? ? 0 : stack
    @sitting_out = true
    @table = nil
    @cards = []
    @log = GameLogger.new
  end

  def join_game game, seat=nil
    raise ArgumentError, "#{@name} cannot join this game, the table is full" if game.table.full?
    raise ArgumentError, "#{@name} cannot join this game, this player is already playing another game" if !@game.nil?
    game.table.add self, seat
    @game = game
  end

  def leave_game
    end_session
    @game = nil
  end

  def start_session
    raise ArgumentError, "#{@name} is not sitting at a table" if @game.nil?
    @sitting_out = false
  end

  def end_session
    @sitting_out = true
  end

  def sitting_out?
    @sitting_out
  end

  def add card
    @cards << card
  end

  def starting_hand
    StartingHand.new(@cards)
  end

  def post_small_blind
    raise_error_if_sitting_out "cannot post the small blind"
    @game.place_bet @game.buy_in / 200.00
  end

  def post_big_blind
    raise_error_if_sitting_out "cannot post the big blind"
    @game.place_bet @game.buy_in / 100.00
  end

  def act
    raise_error_if_sitting_out "cannot act"
    action = "folds"
    @log.info("#{name} #{action}")
  end

  private

  def raise_error_if_sitting_out message
    raise ArgumentError, "#{name} has not joined a game, #{message}" if game.nil?
    raise ArgumentError, "#{name} is sitting out, #{message}" if sitting_out?
  end

end
