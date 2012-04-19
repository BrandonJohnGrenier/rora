require 'csv'
require 'singleton'

class HandRepository
  include Singleton
  attr_reader :table, :hands

  def initialize
    @hands = Deck.new.combination(5)
    @table = Hash.new
    CSV.foreach("lib/rora/hands.csv") do |row|
      @table[row[1].to_i] = [row[0].to_i, row[3], row[4], row[5].to_f]
    end
  end

  def find id
    @table.fetch id
  end

  # Returns all possible poker hands.
  #
  # If no arguments are provided, this method will return all
  # 2,598,960 (52c5) poker hands.
  #
  # If a starting hand is provided as an argument, this method returns
  # all poker hands that can be made with the given starting hand. If a
  # deck is not provided, it is assumed that a deck will contain exactly
  # 50 cards. As a result, exactly 19,600 (50c3) 5-card poker hands will
  # be returned for any given starting hand.
  #
  # If a starting hand and deck are provided as arguments, this method
  # will return all poker hands that can be made with the cards that
  # remain in the deck and the starting hand.
  def list(starting_hand = nil, deck = Deck.new)
    return @hands if starting_hand.nil?

    hands = Array.new
    deck.remove(starting_hand).combination(3).each do |record|
      hands << [record, starting_hand.cards]
    end
    return hands
  end

end
