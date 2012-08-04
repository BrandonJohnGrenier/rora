class StartingHandRepository
  include Singleton
  attr_reader :all, :distinct

  def initialize
    @all = Array.new
    @distinct = Hash.new
    Deck.new.cards.combination(2) do |combination|
      starting_hand = StartingHand.new(combination)
      @all << starting_hand
      hash_key = starting_hand.cards.inject(1) {|product, card| product * card.rank.id } * (starting_hand.suited? ? 67 : 1)
      @distinct[hash_key] = starting_hand
    end
  end

  def all_starting_hands
    @all
  end

  def distinct_starting_hands
    @distinct.values
  end

end