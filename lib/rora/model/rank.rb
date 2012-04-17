#
# The thirteen different hierarchical values in a deck of cards.
#
# A deck of cards has thirteen ranks: 2, 3, 4, 5, 6, 7, 8, 9, 10, Jack, Queen,
# King, Ace.
#
# The ranks have a natural order, with the weakest value (0) assigned to the 2
# and the strongest value (12) assigned to the ace.
#
class Rank
  attr_reader :id, :key, :value, :order

  def initialize(id, key, value, order)
    @id = id
    @key = key
    @value = value
    @order = order
  end

  def self.values
    [TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING, ACE]
  end

  def self.get(key)
    self.values.each do |rank|
      return rank if rank.key.casecmp(key) == 0
    end
    raise ArgumentError, "No rank exists for key " + key
  end

  def to_s
    "Rank: id=#{@id}, key='#{@key}', value='#{@value}'"
  end

  class << self
    private :new
  end

	TWO = new(2, "2", "Two", 0)
  THREE = new(3, "3", "Three", 1)
  FOUR = new(5, "4", "Four", 2)
  FIVE = new(7, "5", "Five", 3)
  SIX = new(11, "6", "Six", 4)
  SEVEN = new(13, "7", "Seven", 5)
  EIGHT = new(17, "8", "Eight", 6)
  NINE = new(19, "9", "Nine", 7)
  TEN = new(23, "T", "Ten", 8)
  JACK = new(29, "J", "Jack", 9)
  QUEEN = new(31, "Q", "Queen", 10)
  KING = new(37, "K", "King", 11)
  ACE = new(41, "A", "Ace", 12)
end