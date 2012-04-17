require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandRepositoyTest < ActiveSupport::TestCase

  test "should be able to find a hand by hand id" do
    result = HandRepository.instance.lookup 2101589603
    assert_equal 1, result[0]
    assert_equal "SF", result[1]
    assert_equal "Royal Flush", result[2]
    assert_equal 0.0015, result[3]
  end

  test "should raise an error when attempting to lookup a hand with an invalid id" do
    assert_raise KeyError do
      HandRepository.instance.lookup 210158960345
    end
  end
  
end
