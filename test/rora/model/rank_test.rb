require File.expand_path("../../rora_test", File.dirname(__FILE__))

class RankTest < ActiveSupport::TestCase

  test "should return all ranks" do
    assert_equal(13, Rank.values.size)
  end

  test "should return the correct rank for the given key" do
    assert_equal(Rank::TWO, Rank.get("2"))
    assert_equal(Rank::THREE, Rank.get("3"))
    assert_equal(Rank::FOUR, Rank.get("4"))
    assert_equal(Rank::FIVE, Rank.get("5"))
  end

  test "should perform a case insensitive key lookup" do
    assert_equal(Rank::JACK, Rank.get("j"))
    assert_equal(Rank::QUEEN, Rank.get("q"))
    assert_equal(Rank::KING, Rank.get("k"))
    assert_equal(Rank::ACE, Rank.get("a"))
  end

  test "should raise an error when performing a lookup with an invalid key" do
    assert_raise ArgumentError do
      Rank.get("L")
    end
  end

  test "should raise an error when performing a lookup with an empty key" do
    assert_raise ArgumentError do
      Rank.get("")
    end
  end

  test "should raise an error when performing a lookup with a nil key" do
    assert_raise TypeError do
      Rank.get(nil)
    end
  end

  test "should generate a readable string representation" do
    assert_equal "Rank: id=41, key='A', value='Ace'", Rank::ACE.to_s
  end

end
