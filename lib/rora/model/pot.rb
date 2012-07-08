#
# The sum of money that players wager during a single hand or game.
#
class Pot
  attr_reader :value

  def initialize
    @value = 0
  end
 
  # Adds the specified bet to the pot
  def add bet
    raise ArgumentError, "Can only add positive values" if bet < 0
    @value += bet
    self
  end

  def to_s
    "Pot: " + sprintf("$%.02f" , @value)
  end

end