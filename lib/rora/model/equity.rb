class Equity

  attr_accessor :starting_hand, :total_hands, :hands_won, :hands_tied, :value
  
  def initialize(total_hands_played, total_hands_won, result)
    @starting_hand = result[0]
    @total_hands = total_hands_played
    @hands_won = result[1]
    @hands_tied = total_hands_played - total_hands_won
    total_equity = @hands_won + @hands_tied
    @value = (total_equity == 0 ? 0.00 : total_equity.quo(@total_hands) * 100.00)
  end

  def to_s
    "starting hand: #{@starting_hand.key} => hands: #{@total_hands}, won: #{@hands_won}, tied: #{@hands_tied}, equity: #{sprintf("%05.3f", @value)}%"
  end

end