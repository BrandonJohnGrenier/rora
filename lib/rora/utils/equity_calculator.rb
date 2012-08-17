require 'date'

class EquityCalculator
  
  def initialize
    @hand_repository = HandRepository.instance
    @best_scores = Hash.new
  end

  def calculate_equity(starting_hands, board = Board.new)
    raise ArgumentError, "Must have at least two starting hands for equity comparison" if (starting_hands.nil? || starting_hands.size < 2)
    raise ArgumentError, "There are duplicate cards" if duplicates?(starting_hands, board)

    equity_map = Hash[starting_hands.map{|starting_hand| [starting_hand, 0]}]
    game = Deck.new.remove(merge(starting_hands, board)).combination(5 - board.cards.size)
      
    game.each do |cards| 
      showdown(equity_map, starting_hands, board.cards + cards) 
    end

    total_winning_hands = equity_map.inject(0) {|total, result| total += result[1]}
    equity_map.inject(Hash.new) { |hash, result| hash[result[0]] = Equity.new(game.size, total_winning_hands, result); hash}
  end

  private

  def showdown(results, starting_hands, board_cards)
    @best_scores.clear
    
    starting_hands.each do |starting_hand|
      @best_scores[starting_hand] = @hand_repository.evaluate_7_card_hand((board_cards + starting_hand.cards))[0]
    end
    
    winner = @best_scores.min_by{|key,value| value}
    results[winner[0]] += 1 if(@best_scores.select {|k,v| v == winner[1]}.size == 1)
  end

  def duplicates?(starting_hands, board)
    cards = merge(starting_hands, board)
    cards.uniq.length != cards.length
  end

  def merge(starting_hands, board)
    starting_hands.inject(board.cards) {|cards, starting_hand| cards.concat(starting_hand.cards)}
  end

end