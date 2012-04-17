#
# The four categories in a deck of cards.
#
# Each card bears one of four symbols showing which suit it belongs to. A deck
# of cards has four suits: hearts, clubs, spades, and diamonds.
#
class Suit
  attr_reader :id, :key, :value

  def initialize(id, key, value)
    @id = id
    @key = key
    @value = value
  end

  def self.values
    [HEART, SPADE, CLUB, DIAMOND]
  end

  def self.get(key)
    self.values.each do |suit|
      return suit if suit.key.casecmp(key) == 0
    end
    raise ArgumentError, "No suit exists for key " + key
  end

  def to_s
    "Suit: id=#{@id}, key='#{@key}', value='#{@value}'"
  end

  class << self
    private :new
  end

  HEART = new(43, "H", "Heart")
  SPADE = new(47, "S", "Spade")
  CLUB = new(53, "C", "Club")
  DIAMOND = new(59, "D", "Diamond")
end