#
# Represents a long term relationship between a player and a poker game.
#
class Session
  attr_reader :table, :player, :stack

  def initialize table, player
    @table = table
    @player = player
  end

  def start stack
    @stack = stack
    @sitting_out = false
  end

  def finish
    @sitting_out = true
  end

  def sitting_out?
    @sitting_out
  end

end