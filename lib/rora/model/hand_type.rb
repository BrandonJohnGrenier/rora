#
# The nine different types of 5-card poker hand.
#
# A 5-card poker hand will be one of the following hand types:
#
# 1. High Card
# 2. One Pair
# 3. Two Pair
# 4. Three of a Kind
# 5. Straight
# 6. Flush
# 7. Full House
# 8. Four of a Kind
# 9. Straight Flush
#
class HandType
  attr_reader :key, :value, :order

  def initialize(key, value, order)
    @key = key
    @value = value
    @order = order
  end

  def self.values
    [HIGH_CARD, ONE_PAIR, TWO_PAIR, THREE_OF_A_KIND, STRAIGHT, FLUSH, FULL_HOUSE, FOUR_OF_A_KIND, STRAIGHT_FLUSH]
  end

  def self.get(key)
    self.values.each do |type|
      return type if type.key.casecmp(key) == 0
    end
    raise ArgumentError, "No hand type exists for key " + key
  end

  def to_s
    "HandType: key='#{@key}', value='#{@value}'"
  end

  class << self
    private :new
  end

	HIGH_CARD = new("HC", "High Card", 1)
  ONE_PAIR = new("1P", "One Pair", 2)
  TWO_PAIR = new("2P", "Two Pair", 3)
  THREE_OF_A_KIND = new("3K", "Three of a Kind", 4)
  STRAIGHT = new("ST", "Straight", 5)
  FLUSH = new("FL", "Flush", 6)
  FULL_HOUSE = new("FH", "Full House", 7)
  FOUR_OF_A_KIND = new("4K", "Four of a Kind", 8)
  STRAIGHT_FLUSH = new("SF", "Straight Flush", 9)
end
