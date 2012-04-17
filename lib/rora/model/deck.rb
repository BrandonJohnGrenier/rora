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

	# Removes the specified card from the deck.
	def remove card
    @cards.delete card
  end

	# Removes the specified cards from the deck.
	def remove_all cards
    cards.each { |card| remove card }
  end

  # Determines if the deck contains the given card.
  def contains card
    @cards.include? card
  end

end
