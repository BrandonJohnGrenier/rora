#
# One of 52 of cards that are used to play card games.
#
# A card is comprised of one rank and one suit, with 13 ranks and 4 suits there
# are 52 unique playing cards.  A card can be created in one of two ways:
#
# The first method uses the Rank and Suit enumerators
# card = Card.new(Rank::KING, Suit::HEART)
#
# The second method uses rank and suit values. 
# card = Card.new("KH")
#
# Rank and suit values are case insensitive, so these work as well
# card = Card.new("Kh")
# card = Card.new("kH")
#
class Card
  attr_reader :rank, :suit

  def initialize(*args)
    if(args.size == 2)
      @rank = args[0]
      @suit = args[1]
    end
    if(args.size == 1)
      raise ArgumentError if args[0].length != 2
      @rank = Rank.get(args[0][0])
      @suit = Suit.get(args[0][1])
    end
  end

  def id
    rank.id * suit.id
  end

  def value
    rank.value + suit.value
  end

  def == card
    card.id == self.id
  end

  def to_s
    "Card: id=#{id}, name='#{@rank.value} of #{@suit.value}s', value='#{@rank.key}#{@suit.key}'"
  end
  
end