require 'csv'
require 'singleton'

class HandRepository
  include Singleton
  
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

  def find id
    @five_card_table.has_key?(id) ? @five_card_table.fetch(id) : @seven_card_table.fetch(id)
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
    return hands if arguments.nil? || arguments[:starting_hand].nil?

    starting_hand = arguments[:starting_hand]
    deck = arguments[:deck].nil? ? Deck.new : arguments[:deck]
    board = arguments[:board]
    hands = Array.new

    if !board.nil?
      raise RuntimeError if board.contains_any? starting_hand.cards
      if board.cards.size == 5
        (board.cards + starting_hand.cards).combination(5).to_a.each { |cards| hands << Hand.new(cards) }
      else
        deck.remove(starting_hand).remove(board).combination(5 - board.cards.size).to_a.each do |cards|
          (starting_hand.cards + board.cards + cards).combination(5).to_a.each { |cds| hands << Hand.new(cds) }
        end
      end
      return hands
    end

    deck.remove(starting_hand).combination(3).each { |cards| hands << Hand.new(cards + starting_hand.cards) }
    hands
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
  def list_unique arguments=nil
    results = list arguments
    return results if results.nil? || results.size == 0

    hash = Hash.new
    results.each do |result|
      hash[result.key] = result
    end
    hash.values
  end

  private

  def hands
    if @hands.empty?
      Deck.new.combination(5).each {|cards| @hands << Hand.new(cards)}
    end
    @hands
  end

end
