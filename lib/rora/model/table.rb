#
#
#
class Table
  attr_reader :board, :deck, :pot, :seats

  def initialize seats=nil
    seat_count = seats.nil? ? 9 : seats
    raise ArgumentError, "A table must have at least two seats" if seat_count < 2
    @seats = Array.new seat_count
    @board = Board.new
    @pot = Pot.new
    @deck = Deck.new
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

  def reset
    @board = Board.new
    @pot = Pot.new
    @deck = Deck.new
  end

  def full?
    @seats.select{|x| x.nil?}.empty?
  end

  def empty?
    @seats.select{|x| !x.nil?}.empty?
  end  
  
  def add player, seat_number=nil
    if !seat_number.nil?
      raise ArgumentError, "Seat number #{seat_number} is already taken by another player." if @seats[seat_number - 1] != nil
      raise ArgumentError, "Seat number #{seat_number} does not exist at this table" if seat_number > seats.size || seat_number < 1
      @seats[seat_number - 1] = player
    else
      raise RuntimeError, "Cannot add player, the table is full" if full?
      @seats.each_index do |x|
        if @seats[x].nil?
          @seats[x] = player
          return
        end
      end
    end
    self
  end

  def remove player
    @seats.delete player
    self
  end

end