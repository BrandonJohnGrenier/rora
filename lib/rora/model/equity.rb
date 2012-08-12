class Equity
  
  attr_accessor :starting_hand, :total_hands, :hands_won, :hands_tied, :value
  
  def initialize(total, result)
    @starting_hand = result[0]
    @total_hands = total
    @hands_won = result[1]
    @hands_tied = total - @hands_won
    @value = (@hands_won == 0 ? 0.00 : @hands_won.quo(@total_hands) * 100.00)
  end
  
  def to_s
    "starting hand: #{@starting_hand.key}, total: #{@total_hands}, won: #{@hands_won}, tied: #{@hands_tied}, equity: #{@value}"
  end
  
end