#
# The logical table area where community cards are dealt.
#
# A board can be initialized with flop, turn and river cards.
#
# # A board with the flop set
# board_one = Board.new "AS,KS,QS"
#
# # A board with the flop and turn set
# board_two = Board.new "AS,KS,QS,JS"
#
# # A board with the flop, turn and river set.
# board_three = Board.new "AS,KS,QS,JS,TS"
#
# # An empty baord can be created as well.
# board_four = Board.new
#
# Boards may also be populated programmatically using the flop, turn and
# river methods respectively:
#
# board = Board.new
# board.flop = "AS,KS,QS"
# board.turn = "JS"
# board.river = "TS"
#
class Board
  attr_reader :flop, :turn, :river

  def initialize cards=nil
    return if cards.nil?

    cds = cards.kind_of?(Array) ? cards : Card.to_cards(cards)
    raise ArgumentError, "3 to 5 cards are required to create a board, #{cds.size} cards provided" if cds.size < 3 || cds.size > 5
    raise ArgumentError, "The board contains duplicate cards" if cds.uniq.length != cds.length

    @flop = cds[0..2]
    @turn = cds[3] if cds.size >= 4
    @river = cds[4] if cds.size == 5
  end

  def flop
    @flop.dup if !@flop.nil?
  end

  def flop= cards
    raise ArgumentError, "Cannot deal a flop with empty array of cards" if cards.nil? || cards.empty?

    cds = cards.kind_of?(Array) ? cards : Card.to_cards(cards)
    raise ArgumentError, "3 cards are required on the flop, #{cds.size} cards provided" if cds.size !=3
    raise ArgumentError, "The flop contains duplicate cards" if cds.uniq.length != cds.length
    @flop = cds[0..2]
  end

  def turn= card
    cd = card.kind_of?(Card) ? card : Card.new(card)
    raise RuntimeError, "The flop must be dealt before the turn card is dealt" if @flop.nil?
    raise ArgumentError, "The board already contains the #{cd.name}" if cards.include? cd
    @turn = cd
  end

  def river= card
    cd = card.kind_of?(Card) ? card : Card.new(card)
    raise RuntimeError, "The turn card must be dealt before the river card is dealt" if @turn.nil?
    raise ArgumentError, "The board already contains the #{cd.name}" if cards.include? cd
    @river = cd
  end

  def size
    cards.size
  end

  def cards
    cds = Array.new
    cds += @flop if !@flop.nil?
    cds.push(@turn) if !@turn.nil?
    cds.push(@river) if !@river.nil?
    cds
  end

  # Determines if the board contains the given card.
  def contains? argument
    if argument.kind_of? Card
      return cards.include?(argument)
    end
    cards.include? Card.new(argument)
  end

  # Determines if the board contains any of the given cards.
  def contains_any? argument
    if argument.kind_of? Array
      argument.each {|card| return true if cards.include? card}
    end
    if argument.kind_of? String
      Card.to_cards(argument).each {|card| return true if cards.include? card}
    end
    false
  end

  def to_s
    "Board: flop=#{@flop.map { |card| "#{card.key}" }.join(",")}"
  end

end
