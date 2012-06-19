require File.expand_path("../../rora_test", File.dirname(__FILE__))

class SeatTest < ActiveSupport::TestCase

  def setup
    @seat = Seat.new 2
  end

  test "should raise an error when a seat is created with a seat number less than 1" do
    assert_raise ArgumentError do
      Seat.new 0
    end
  end

  test "the seat should have a seat number" do
    assert_equal 2, @seat.number
  end

  test "the seat should not be taken when a player is not sitting in it" do
    assert_equal false, @seat.taken?
  end

  test "the seat should  be taken when a player is  sitting in it" do
    @seat.player = "player"
    assert_equal true, @seat.taken?
  end

  test "the seat should not have the dealer button" do
    assert_equal false, @seat.button?
  end

  test "the seat should have the dealer button" do
    @seat.button = true
    assert_equal true, @seat.button?
  end

  test "should return a string representation of the seat" do
    assert_equal "Seat: 2", @seat.to_s
  end

end
