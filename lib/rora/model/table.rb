#
#
#
class Table
  attr_reader :board, :deck, :pot

  def initialize seats=nil
    seats = seats.nil? ? 9 : seats
    raise ArgumentError, "A table must have at least two seats" if seats < 2
    @seats = Array.new seats
    @board = Board.new
    @pot = Pot.new
    @deck = Deck.new

    @seats.each_index {|index| @seats[index] = Seat.new(index + 1)}
    @seats.each_index do |index|
      @seats[index].next = @seats[index == seats ? 0 : index + 1]
      @seats[index].prev = @seats[index == 0 ? seats - 1 : index - 1]
    end
  end

  def with argument
    if argument.kind_of? Deck
      @deck = argument
    end
    if argument.kind_of? Pot
      @pot = argument
    end
    if argument.kind_of? Board
      @board = argument
    end
    self
  end

  def seat
    @seats
  end

  def size
    @seats.size
  end

  def reset
    @board = Board.new
    @pot = Pot.new
    @deck = Deck.new
  end

  def full?
    @seats.select{|x| !x.taken?}.empty?
  end

  def empty?
    @seats.select{|x| x.taken?}.empty?
  end

  def add player, seat_number=nil
    raise RuntimeError, "Cannot add player, the table is full" if full?
    if !seat_number.nil?
      raise ArgumentError, "Seat number #{seat_number} does not exist at this table" if seat_number > @seats.size || seat_number < 1
      raise ArgumentError, "Seat number #{seat_number} is already taken by another player." if @seats[seat_number - 1].taken?
      @seats[seat_number - 1].player = player
    else
      @seats.each_index do |x|
        if !@seats[x].taken?
          @seats[x].player = player
          return
        end
      end
    end
    self
  end

  def remove player
    @seats.delete_if {|seat| seat.player == player}
    self
  end

end