#
# A subset of cards held at one time by a player during a game.
#
# A hand consists of exactly five cards, and can be created in one of two ways.
#
# A hand can be created with an array of cards.
# hand = Hand.new([c1,c2,c3,c4,c5])
#
# A hand can be created with string representation of each card.
# hand = Hand.new("ACKCJS9H4H")
#
class Hand
  attr_reader :cards

  def initialize cards
    @hand_repository = HandRepository.instance
    @cards = cards.kind_of?(Array) ? cards : Card.to_cards(cards)
    raise ArgumentError, "Exactly 5 cards are required to create a hand, #{cards.size} provided" if @cards.size != 5
    raise ArgumentError, "The hand contains duplicate cards" if @cards.uniq.length != @cards.length
  end

  # Returns the hand id.
  def id
    @cards.inject(1) {|product, card| product * card.id }
  end

  # Returns the hand hash key.
  def hash_key
    @cards.inject(1) {|product, card| product * card.rank.id } * (flush? ? 67 : 1)
  end

  # Returns the hand value.
  def value
    @cards.map { |card| "#{card.key}" }.join(",")
  end

  # Returns the hand strength, from 1 (strongest) to 7462 (weakest).
  def score
    resolve_hand_attribute(0)
  end

  # Returns the probability of this hand being dealt.
  def probability
    resolve_hand_attribute(3)
  end

  # Returns the hand name.
  def name
    resolve_hand_attribute(2)
  end

  # Returns the hand type.
  def type
    HandType.get resolve_hand_attribute(1)
  end

  # Returns all cards contained in the hand.
  def cards
    @cards.dup
  end

  # Determines if this hand is a flush.
  def flush?
    for i in 0..(@cards.size - 2) do
      return false if @cards[i].suit != @cards[i+1].suit
    end
    true
  end

  # Determines if this hand is a straight flush.
  def straight_flush?
    type == HandType::STRAIGHT_FLUSH
  end

  # Determines if this hand is four of a kind.
  def four_of_a_kind?
    type == HandType::FOUR_OF_A_KIND
  end

  # Determines if this hand is a full house.
  def full_house?
    type == HandType::FULL_HOUSE
  end

  # Determines if this hand is a straight.
  def straight?
    type == HandType::STRAIGHT
  end

  # Determines if this hand is a three of a kind.
  def three_of_a_kind?
    type == HandType::THREE_OF_A_KIND
  end

  # Determines if this hand is two pair.
  def two_pair?
    type == HandType::TWO_PAIR
  end

  # Determines if this hand has one pair.
  def one_pair?
    type == HandType::ONE_PAIR
  end

  # Determines if this hand is a high card.
  def high_card?
    type == HandType::HIGH_CARD
  end

  # Determines if this hand contains the given cards.
  def contains cards
    @cards.contains cards
  end

  private

  def resolve_hand_attribute value
    @hand_repository.find(hash_key)[value]
  end

end
