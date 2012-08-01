#
# Two cards, also known as hole cards or pocket cards, which belong solely to
# one player and remain hidden from the other players.
#
class StartingHand
  attr_reader :key, :cards
  
  def initialize cards
    @cards = Array.new, @id = 1, @key = 1

    @cards = cards.kind_of?(Array) ? cards : Card.to_cards(cards)
    raise ArgumentError, "Exactly 2 cards are required to create a starting hand, #{@cards.size} provided" if @cards.size != 2
    raise ArgumentError, "The starting hand contains duplicate cards" if @cards.uniq.length != @cards.length

    @key = @cards.inject(1) {|product, card| product * card.rank.id } * (suited? ? 67 : 1)
  end

  # Returns all cards contained in the starting hand.
  def cards
    @cards.dup
  end

  # Returns the starting hand value.
  def value
    @cards.map { |card| "#{card.key}" }.join(",")
  end

  # Returns the shorthand notation for the starting hand.
  #
  # It is often desirable to have a short hand notation for starting hands,
  # ignoring card suits and simply describing whether the starting hand is
  # suited or not. The shorthand notation removes suit characters, and
  # appends an 'o' (offsuit) or 's' (suited) to the card ranks.
  #
  # Starting hand consisting of the Ace of Clubs and Jack of Clubs:
  # card.value == 'AC,JC'
  # card.short_value == 'JCs'
  #
  # Starting hand consisting of the Ten of Hearts and Eight of Clubs:
  # card.value == 'TH,8C',
  # card.short_value == 'T8o'
  def short_value
    @cards[0].rank.key + @cards[1].rank.key + (suited? ? "s" : "o")
  end

  # Determines if the starting hand is a pocket pair.
  def pocket_pair?
    cards[0].rank == cards[1].rank
  end

  # Determines if the starting hand is suited.
  def suited?
    for i in 0..@cards.size - 2 do
      return false if @cards[i].suit != @cards[i+1].suit
    end
    true
  end

  # Returns all possible starting hands.
  #
  # There are exaclty 1,326 (52c2) starting hands. This method returns
  # a list containing every possible starting hand.
  def self.all_starting_hands
    StartingHandRepository.instance.all_starting_hands
  end

  # Returns all distinct starting hands.
  #
  # While there are 1,324 starting hands, many of these starting hands have
  # the same value in poker. To elaborate on this a bit, consider the
  # number of hands a player could have containing a Jack and a Seven:
  #
  # J♣ 7♦
  # J♠ 7♦
  # J♥ 7♦
  # J♦ 7♦
  # J♣ 7♠
  # J♠ 7♠
  # J♥ 7♠
  # J♦ 7♠
  # J♣ 4♥
  # J♠ 4♥
  #
  # This list goes on a bit further further. You might be surprised to know
  # that there are 16 starting hand combinations that contain exactly one
  # Jack and one Seven. Out of this list of 16, only two card values have any
  # relevance in a poker game - Jack-Seven suited and Jack-Seven unsuited.
  #
  # This exercise demonstrates that while there are 1,324 starting hands to
  # contend with, the number of distinct starting hands is dramatically
  # lower. This is because card suits don’t tend to affect the score of the
  # hand.
  #
  # Once all 1,324 poker hands are collapsed into distinct values, we end up
  # with just 169 starting hands!
  def self.distinct_starting_hands
    StartingHandRepository.instance.distinct_starting_hands
  end

  def eql? starting_hand
    self == starting_hand
  end

  def == starting_hand
    self.id == starting_hand.id
  end

  def hash
    return self.id
  end

  def to_s
    @cards[0].to_s + ", " + @cards[1].to_s
  end

end
