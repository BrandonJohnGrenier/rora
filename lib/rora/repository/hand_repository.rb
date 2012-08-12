require 'csv'
require 'singleton'

class HandRepository
  include Singleton

  HEART_FLUSH=32
  DIAMOND_FLUSH=243
  SPADE_FLUSH=3125
  CLUB_FLUSH=16807

  def initialize
    @hands = Array.new

    @five_card_table = Hash.new
    CSV.foreach("lib/rora/5-card-hands.csv") do |row|
      @five_card_table[row[1].to_i] = [row[0].to_i, row[3], row[4]]
    end

    @seven_card_table = Hash.new
    CSV.foreach("lib/rora/7-card-hands.csv") do |row|
      @seven_card_table[row[1].to_i] = [row[0].to_i, row[4], row[5]]
    end
  end

  def evaluate_5_card_hand(cards)
    key = cards.inject(1) {|product, card| product * card.rank.id } * (flush?(cards) ? 67 : 1)
    @five_card_table.fetch(key)
  end

  def evaluate_7_card_hand(cards)
    flush = contains_flush?(cards)
    return get_best_hand(cards) if flush
    
    key = 1
    cards.each {|card| key = key * card.rank.id}
    @seven_card_table.fetch(key)
  end

  def contains_flush?(cards)
    key = 1
    cards.each {|card| key = key * card.suit.id}
    key % HEART_FLUSH == 0 || key % DIAMOND_FLUSH == 0 || key % SPADE_FLUSH == 0 || key % CLUB_FLUSH == 0
  end

  def get_best_hand(cards)
    hands = cards.combination(5).to_a.each.collect { |selection| Hand.new(selection) }
    hands.sort {|x,y| x.score <=> y.score }[0].score
  end

  # Returns all possible poker hands.
  #
  # No Arguments
  # If no arguments are provided, this method will return all
  # 2,598,960 (52c5) poker hands.
  #
  # Starting Hand
  # If a starting hand is provided as an argument, this method returns all
  # poker hands that can be made with the given starting hand. A standard
  # deck of 52 cards is assumed. Exactly 19,600 (50c3) 5-card poker hands
  # will be returned for any given starting hand.
  #
  # Starting Hand and Deck
  # If a deck is provided along with a starting hand, this method will return
  # all poker hands that can be made with the given starting hand and cards
  # that remain in the deck.
  #
  # Starting Hand and Board
  # If a board is provided along with a starting hand, this method will return
  # all poker hands that can be made with the given starting hand and board. In
  # this scenario, a standard deck of 52 cards is assumed. A deck will contain
  # exactly 50 cards after the starting hand has been dealt. The deck will contain
  # 47 cards after the flop, 46 cards after the turn and 45 cards after the river.
  #
  # Once the community cards have been dealt, there are 21 (7c5) ways to
  # choose a 5-card poker hand from the 5 community cards and 2 hole cards.
  # The total number of hands that will be returned from this method are as
  # follows:
  #
  # If the board has 5 community cards, flop turn & river have been
  # dealt:
  # 21 hands -> 21 (7c5) # 1 (45c0)
  #
  # If the board has 4 community cards, flop and turn have been dealt:
  # 966 hands -> 21 (7c5) # 46 (46c1)
  #
  # If the board has 3 community cards, flop has been dealt:
  # 22701 hands -> 21 (7c5) # 1081 (47c2)
  #
  # Starting Hand, Board and Deck
  # This method will return all poker hands that can be made with the given starting
  # hand and cards that remain in the deck.
  def list arguments=nil
    return all_hands if arguments.nil? || arguments[:starting_hand].nil?

    starting_hand = arguments[:starting_hand]
    deck = arguments[:deck].nil? ? Deck.new : arguments[:deck]
    board = arguments[:board]
    spec_hands = Array.new

    if !board.nil?
      raise RuntimeError if board.contains_any? starting_hand.cards
      if board.cards.size == 5
        (board.cards + starting_hand.cards).combination(5).to_a.each { |cards| spec_hands << Hand.new(cards) }
      else
        deck.remove(starting_hand).remove(board).combination(5 - board.cards.size).to_a.each do |cards|
          (starting_hand.cards + board.cards + cards).combination(5).to_a.each { |cds| spec_hands << Hand.new(cds) }
        end
      end
      return spec_hands
    end

    deck.remove(starting_hand).combination(3).each { |cards| spec_hands << Hand.new(cards + starting_hand.cards) }
    spec_hands
  end

  # Returns unique poker hands.
  #
  # While there are over 2.5 million distinct poker hands, many of these hands have the same
  # value in poker. To elaborate on this a bit, consider the number of hands a player could have
  # containing a pair of fours with a 10-7-6 kicker:
  #
  # 4♣ 4♦ 6♠ 7♥ 10♥
  # 4♠ 4♦ 6♠ 7♥ 10♥
  # 4♥ 4♦ 6♠ 7♥ 10♥
  # 4♣ 4♠ 6♠ 7♥ 10♥
  # 4♣ 4♦ 6♠ 7♥ 10♦
  # 4♣ 4♦ 6♠ 7♦ 10♥
  # 4♣ 4♦ 6♣ 7♥ 10♥
  # 4♣ 4♦ 6♠ 7♠ 10♥
  # 4♣ 4♦ 6♠ 7♦ 10♠
  # 4♣ 4♦ 6♣ 7♥ 10♣
  #
  # This list goes on much further - in fact, there are exactly 768 distinct hand combinations that
  # contain of exactly one pair of fours with a 10-7-6 kicker. Each of these 768 hands has the same
  # hand value, or score.
  #
  # This exercise demonstrates that the number of unique hands (that is, hands that share an identical
  # hand score) is significantly lower than the number of distinct hands. This is because card suits
  # don’t tend to affect the score of a hand  (the only exception being a flush).
  #
  # This method carries the same semantics as the list method, but returns unique hands instead of
  # every possible hand.
  def list_and_group_by_hand_score arguments=nil
    spec_hands = list arguments
    return spec_hands if spec_hands.nil? || spec_hands.size == 0

    hash = Hash.new
    spec_hands.each do |hand|
      hash[(hand.cards.inject(1) {|product, card| product * card.rank.id } * (flush?(hand.cards) ? 67 : 1))] = hand
    end
    hash.values
  end

  private

  def flush?(cards)
    for i in 0..(cards.size - 2) do
      return false if cards[i].suit != cards[i+1].suit
    end
    true
  end

  def all_hands
    if @hands.empty?
      Deck.new.combination(5).each {|cards| @hands << Hand.new(cards)}
    end
    @hands
  end

end
