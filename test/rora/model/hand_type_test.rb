require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandTypeTest < ActiveSupport::TestCase

  test "should return all hand types" do
    assert_equal 9, HandType.values.size
  end

  test "should return the correct hand type for the given key" do
    assert_equal HandType::HIGH_CARD, HandType.get("HC")
  end

  test "should perform a case insensitive key lookup" do
    assert_equal(HandType::HIGH_CARD, HandType.get("Hc"))
  end

  test "should raise an error when performing a lookup with an invalid key" do
    assert_raise ArgumentError do
      HandType.get "L"
    end
  end

  test "should raise an error when performing a lookup with an empty key" do
    assert_raise ArgumentError do
      HandType.get ""
    end
  end

  test "should raise an error when performing a lookup with a nil key" do
    assert_raise TypeError do
      HandType.get nil
    end
  end

  test "should generate a readable string representation" do
    assert_equal "HandType: key='FL', value='Flush'", HandType::FLUSH.to_s
  end

end
