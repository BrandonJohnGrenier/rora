#
# A seat at a poker table.
#
# Once a table is constructed, each seat at the table will contain a reference to
# the seat before it and the seat after it. In effect, the seat implements a very
# basic doubly-linked list.
#
class Seat
  attr_accessor :prev, :next, :player
  attr_reader :number

  def initialize number
    raise ArgumentError, "Must create a seat number with a value of 1 or greater" if number < 1
    @number = number
  end

  # Determines whether the seat is taken.
  def taken?
    return !@player.nil?
  end

  def to_s
    "Seat number #{@number}"
  end

end