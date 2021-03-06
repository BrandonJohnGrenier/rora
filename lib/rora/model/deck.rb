#
# A complete set of 52 playing cards.
#
# A deck of cards may be used for playing a great variety of card games, with
# varying elements of skill and chance, some of which are played for money.
#
class Deck
  attr_reader :cards

  def initialize
    @cards = Array.new
    Suit.values.each do |suit|
      Rank.values.each do |rank|
        @cards << Card.new(rank, suit)
      end
    end
    @cards.sort!
  end

  # Retains all cards with the given suit or rank, removing all others.
  def retain_all argument
    if argument.kind_of? Suit
      @cards = @cards.find_all{|card| card.suit.eql?(argument) }
    end
    if argument.kind_of? Rank
      @cards = @cards.find_all{|card| card.rank.eql?(argument) }
    end
    self
  end

  # Removes all cards with the given suit or rank, retaining all others.
  def remove_all argument
    if argument.kind_of? Suit
      @cards = @cards.find_all{|card| !card.suit.eql?(argument) }
    end
    if argument.kind_of? Rank
      @cards = @cards.find_all{|card| !card.rank.eql?(argument) }
    end
    self
  end

  # Shuffles all cards in the deck.
  def shuffle
    @cards.shuffle!
    self
  end

  # Returns the number of cards in the deck.
  def size
    @cards.size
  end

  # Deals a single card from the deck.
  def deal
    @cards.delete_at 0
  end

  # Determines if the deck is empty.
  def empty?
    @cards.empty?
  end

  # Returns a shallow copy of the cards in the deck.
  def cards
    @cards.dup
  end

  # Returns the total number of cards with the given rank in the deck.
  def count_cards_with_rank rank
    count = 0;
    @cards.each do |card|
      count +=1 if card.rank.eql?(rank)
    end
    count
  end

  # Returns the total number of cards with the given suit in the deck.
  def count_cards_with_suit suit
    count = 0;
    @cards.each do |card|
      count +=1 if card.suit.eql?(suit)
    end
    count
  end

  # Removes cards from the deck.
  #
  # This method can remove a Card, an Enumerable (an Array or Hash
  # of Cards) or a StartingHand from the deck.
  def remove argument
    if argument.kind_of? Card
      @cards.delete argument
    end
    if argument.kind_of? Enumerable
      argument.each { |card| @cards.delete card }
    end
    if argument.kind_of? StartingHand
      argument.cards.each { |card| @cards.delete card }
    end
    if argument.kind_of? Board
      argument.cards.each { |card| @cards.delete card }
    end
    if argument.kind_of? String
      Card.to_cards(argument).each { |card| @cards.delete card }
    end
    self
  end

  # Determines if the deck contains the given card.
  def contains? argument
    if argument.kind_of? Card
      return @cards.include?(argument)
    end
    @cards.include? Card.new(argument)
  end

  # Determines if the deck contains any of the given cards.
  def contains_any? argument
    if argument.kind_of? Array
      argument.each {|card| return true if @cards.include? card}
    end
    if argument.kind_of? String
      Card.to_cards(argument).each {|card| return true if @cards.include? card}
    end
    false
  end

  def combination number
    cards.combination(number).to_a
  end

end
