class EquityCalculator

  def initialize
    @hand_repository = HandRepository.instance
  end

  def calculate_equity(starting_hands, board = Board.new)
    raise ArgumentError, "Must have at least two starting hands for equity comparison" if (starting_hands.nil? || starting_hands.size < 2)
    raise ArgumentError, "There are duplicate cards" if contains_duplicates? starting_hands, board

    results = Hash[starting_hands.map{|starting_hand| [starting_hand, 0]}]
    collection = Deck.new.remove(merge(starting_hands, board)).combination(5 - board.cards.size)
    collection.each { |cards| showdown(results, starting_hands, board.cards + cards) }
    results.inject(Hash.new) { |hash, result| hash[result[0]] = Equity.new(collection.size, result); hash}
  end

  private

  def showdown(results, starting_hands, board_cards)
    best_hands = starting_hands.inject(Hash.new) { |hash, starting_hand| hash[starting_hand] = @hand_repository.evaluate_7_card_hand((board_cards + starting_hand.cards))[0]; hash}
    top_hand = best_hands.min_by{|key,value| value}
    top_score = top_hand[1]
    results[top_hand[0]] += 1 if(best_hands.select {|k,v| v == top_score}.size == 1)
  end

  def contains_duplicates?(starting_hands, board)
    cards = merge(starting_hands, board)
    cards.uniq.length != cards.length
  end

  def merge(starting_hands, board)
    starting_hands.inject(board.cards) {|cards, starting_hand| cards.concat(starting_hand.cards)}
  end

end