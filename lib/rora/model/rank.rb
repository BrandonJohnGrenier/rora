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
  include Comparable

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
      return rank if(rank.key.casecmp(key) == 0)
    end
    raise ArgumentError, "No rank exists for key '#{key}'"
  end

  def <=>(rank)
    self.order <=> rank.order
  end

  def eql? rank
    self == rank
  end

  def == rank
    self.key == rank.key
  end

  def hash
    return self.rank.ord
  end

  def to_s
    "#{@value}"
  end

  class << self
    private :new
  end

  TWO = new(2, "2", "Two", 13)
  THREE = new(3, "3", "Three", 12)
  FOUR = new(5, "4", "Four", 11)
  FIVE = new(7, "5", "Five", 10)
  SIX = new(11, "6", "Six", 9)
  SEVEN = new(13, "7", "Seven", 8)
  EIGHT = new(17, "8", "Eight", 7)
  NINE = new(19, "9", "Nine", 6)
  TEN = new(23, "T", "Ten", 5)
  JACK = new(29, "J", "Jack", 4)
  QUEEN = new(31, "Q", "Queen", 3)
  KING = new(37, "K", "King", 2)
  ACE = new(41, "A", "Ace", 1)
end