#
# A player in a Texas Hold'em game.
#
class Player
  attr_reader :name, :stack, :table

  def initialize name, stack
    raise ArgumentError, "The player name cannot be nil" if name.nil?
    @name = name
    @stack = stack.nil? ? 0 : stack
    @sitting_out = true
    @table = nil
    @cards = []
  end

  def join_table table, seat=nil
    raise ArgumentError, "This table is full" if table.full?
    raise ArgumentError, "#{@name} is already sitting at a table" if !@table.nil?
    table.add self, seat
    @table = table
  end

  def leave_table
    end_session
    @table = nil
  end

  def start_session
    raise ArgumentError, "#{@name} is not sitting at a table" if @table.nil?
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

  def act table
    "fold"
  end

end
