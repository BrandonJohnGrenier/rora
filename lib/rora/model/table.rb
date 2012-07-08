#
# A poker table where players compete for pots.
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
      @seats[index].next = @seats[index == (seats - 1) ? 0 : index + 1]
      @seats[index].prev = @seats[index == 0 ? seats - 1 : index - 1]
    end
  end

  def pass_the_buck
    index = the_button.number - 1
    @seats[index].button = nil
    the_seat_after(@seats[index]).button = true
  end

  def the_button
    raise RuntimeError, "There are fewer than two players at the table" if players.size < 2
    @seats.each_index do |x|
      return @seats[x] if @seats[x].button?
    end
    @seats.each_index do |x|
      return @seats[x] if @seats[x].taken?
    end
  end

  def the_small_blind
    players.size == 2 ? the_button : the_seat_after(the_button)
  end

  def the_big_blind
    the_seat_after the_small_blind
  end

  def under_the_gun
    the_seat_after(the_big_blind)
  end

  def the_seat_after seat
    raise RuntimeError, "There are fewer than two players at the table" if players.size < 2
    this_seat = seat.next
    return this_seat.taken? ? this_seat : the_seat_after(this_seat)
  end

  def the_seat_before seat
    raise RuntimeError, "There are fewer than two players at the table" if players.size < 2
    this_seat = seat.prev
    return this_seat.taken? ? this_seat : the_seat_before(this_seat)
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

  def seat i
    @seats[i - 1]
  end

  def size
    @seats.size
  end

  def reset
    @board = Board.new
    @pot = Pot.new
    @deck = Deck.new
  end

  def players
    players = []
    @seats.each do |seat|
      players << seat.player if seat.taken?
    end
    players
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
      raise ArgumentError, "Seat number #{seat_number} is already taken by another player" if @seats[seat_number - 1].taken?
      @seats[seat_number - 1].player = player
      return self
    end
    @seats.each_index do |x|
      if !@seats[x].taken?
        @seats[x].player = player
        return self
      end
    end
    self
  end

  def remove player
    @seats.each_index do |x|
      if @seats[x].player == player
        @seats[x].player = nil
      end
    end
  end

end