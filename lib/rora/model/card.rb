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
  include Comparable

  attr_reader :rank, :suit, :key, :uid
  
  def initialize(*args)
    if(args.size == 2)
      @rank = args[0]
      @suit = args[1]
    end
    if(args.size == 1)
      raise ArgumentError, "#{args[0]} is an invalid card sequence" if args[0].length != 2
      @rank = Rank.get(args[0][0].chr)
      @suit = Suit.get(args[0][1].chr)
    end
    @key =  @rank.key + @suit.key
    @card_repository = CardRepository.instance
    @uid = @card_repository.get(@key)
  end

  def <=>(card)
    return self.rank <=> card.rank if card.rank != self.rank
    self.suit <=> card.suit
  end

  def value
    "#{@rank.value} of #{@suit.value}s"
  end

  def eql? card
    self == card
  end

  def == card
    return false if !card.kind_of? Card
    uid == card.uid
  end

  def hash
     uid
  end

  def self.to_cards string
    cards = Array.new
    if !string.include?(",") && !string.include?(" ")
      string.scan(/../).each { |chars| cards << Card.new(chars) }
    else
      string.split(string.include?(",") ? "," : " ").each { |chars| cards << Card.new(chars) }
    end
    cards
  end

  def to_s
    "#{value}"
  end

end