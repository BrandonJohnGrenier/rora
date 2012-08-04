require File.expand_path("../../rora_test", File.dirname(__FILE__))

class SuitTest < ActiveSupport::TestCase

  test "should return all suits" do
    assert_equal(4, Suit.values.size)
  end

  test "should return the correct suit for the given key" do
    assert_equal(Suit::SPADE, Suit.get("S"))
    assert_equal(Suit::HEART, Suit.get("H"))
    assert_equal(Suit::DIAMOND, Suit.get("D"))
    assert_equal(Suit::CLUB, Suit.get("C"))
  end

  test "should perform a case insensitive key lookup" do
    assert_equal(Suit::SPADE, Suit.get("s"))
    assert_equal(Suit::DIAMOND, Suit.get("d"))
    assert_equal(Suit::CLUB, Suit.get("c"))
    assert_equal(Suit::HEART, Suit.get("h"))
  end

  test "should raise an error when performing a lookup with an invalid key" do
    assert_raise_message "No suit exists for key 'L'", ArgumentError do
      Suit.get("L")
    end
  end

  test "should raise an error when performing a lookup with an empty key" do
    assert_raise_message "No suit exists for key ''",  ArgumentError do
      Suit.get("")
    end
  end

  test "should raise an error when performing a lookup with a nil key" do
    assert_raise TypeError do
      Suit.get(nil)
    end
  end

  test "should generate a readable string representation" do
    assert_equal "Spades", Suit::SPADE.to_s
  end

end
