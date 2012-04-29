#
# The sum of money that players wager during a single hand or game.
#
class Pot

  attr_reader :value

  def initialize
    @value = 0
  end

  def add bet
    @value += bet
    self
  end

  def to_s
    "Pot: " + sprintf("$%.02f" , @value)
  end

end