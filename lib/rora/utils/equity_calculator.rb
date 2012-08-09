class EquityCalculator
  
  def initialize
    @hand_repository = HandRepository.instance
  end

  def calculate_equity(starting_hands, board = Board.new)
    raise ArgumentError, "Must have at least two starting hands for equity comparison" if (starting_hands.nil? || starting_hands.size < 2)
    raise ArgumentError, "There are duplicate cards" if contains_duplicates? starting_hands, board

    results = Hash[starting_hands.map{|starting_hand| [starting_hand, 0]}]

    deck = Deck.new.remove(merge_cards(starting_hands, board))
    deck.combination(5 - board.cards.size).each do |cards|
      showdown(results, starting_hands, board.cards + cards)
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

  def showdown(results, starting_hands, board_cards)
    best_hands = starting_hands.inject(Hash.new(0)) { |hash, starting_hand| hash[starting_hand] = @hand_repository.evaluate_7_card_hand((board_cards + starting_hand.cards))[0]; hash}
    best_hand = best_hands.min_by{|key,value| value}
    best_score = best_hand[1]
    results[best_hand[0]] += 1 if(best_hands.select {|k,v| v == best_score}.size == 1)
  end

  def contains_duplicates?(starting_hands, board)
    cards = merge_cards(starting_hands, board)
    cards.uniq.length != cards.length
  end

  def merge_cards(starting_hands, board)
    cards = board.cards
    starting_hands.each { |starting_hand | cards.concat(starting_hand.cards) }
    cards
  end

end