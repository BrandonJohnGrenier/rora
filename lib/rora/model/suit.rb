#
# The four categories in a deck of cards.
#
# Each card bears one of four symbols showing which suit it belongs to. A deck
# of cards has four suits: hearts, clubs, spades, and diamonds.
#
class Suit
  include Comparable
  
  attr_reader :id, :key, :value, :order
  
  def initialize(id, key, value, order)
    @id = id
    @key = key
    @value = value
    @order = order
  end

  def self.values
    [HEART, SPADE, CLUB, DIAMOND]
  end

  def self.get(key)
    self.values.each do |suit|
      return suit if suit.key.casecmp(key) == 0
    end
    raise ArgumentError, "No suit exists for key '#{key}'"
  end

  def <=>(suit)
    self.order <=> suit.order
  end

  def eql? suit
    self == suit
  end

  def == suit
    self.key == suit.key
  end

  def hash
    return self.key.ord
  end

  def to_s
    "#{@value}s"
  end

  class << self
    private :new
  end

  HEART = new(0, "H", "Heart", 1)
  DIAMOND = new(57, "D", "Diamond", 2)
  SPADE = new(1, "S", "Spade", 3)
  CLUB = new(8, "C", "Club", 4)
end