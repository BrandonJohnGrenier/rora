class EquityCalculator
  
  def self.calculate_equity(starting_hands, board = Board.new)
    raise ArgumentError, "Must have at least two starting hands for equity comparison" if (starting_hands.nil? || starting_hands.size < 2)
    raise ArgumentError, "There are duplicate cards" if EquityCalculator.contains_duplicates? starting_hands, board

    results = Hash[starting_hands.map{ |starting_hand| [starting_hand, 0] }]

    deck = Deck.new.remove(EquityCalculator.merge_cards(starting_hands, board))
    i = 0
    start = Time.now
    deck.combination(5 - board.cards.size).each do | cards |
      EquityCalculator.showdown(results, starting_hands, board.cards + cards)
      i = i + 1
      if i % 5000 == 0
        current = Time.now
        delta = ((current - start) * 1000.0).to_i
        puts "round #{i}, time #{delta}"
      end
    end

    total = deck.combination(5 - board.cards.size).size

    equities = Hash.new
    results.each do |result|
      equity = Equity.new
      equity.value = result[1].quo(total) * 100.00
      equity.total_hands = total
      equity.hands_won = result[1]
      equity.hands_tied = total - result[1]
      equity.starting_hand = result[0]
      equities[result[0]] = equity
    end

    equities
  end

  private

  def self.showdown equity_results, starting_hands, board_cards
    scores = Hash.new

    starting_hands.each do |starting_hand|
      best_hand = get_best_hand(board_cards, starting_hand)
      scores[starting_hand] = best_hand.score
    end

    winner = scores.min_by{|key,value| value}
    winner_score = winner[1]

    number_of_identical_hand_scores = 0
    scores.each_value do |score|
      if(score == winner_score)
        number_of_identical_hand_scores += 1
      end
    end

    if(number_of_identical_hand_scores == 1)
      equity_results[winner[0]] += 1
    end
  end

  def self.get_best_hand(board_cards, starting_hand)
    hands = []
    (board_cards + starting_hand.cards).combination(5).to_a.each { |cards| hands << Hand.new(cards) }
    hands.sort {|x,y| x.score <=> y.score }[0]
  end

  def self.contains_duplicates? starting_hands, board
    cards = EquityCalculator.merge_cards(starting_hands, board)
    cards.uniq.length != cards.length
  end

  def self.merge_cards(starting_hands, board)
    cards = board.cards
    starting_hands.each { |starting_hand | cards.concat(starting_hand.cards) }
    cards
  end

end