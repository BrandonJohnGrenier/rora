require File.expand_path("../../rora_test", File.dirname(__FILE__))

class PotTest < ActiveSupport::TestCase
  
  def setup
    @pot = Pot.new
  end

  test "a new post should have a total of 0 dollars" do
    assert_equal 0, @pot.value
  end

  test "should raise an error when attempting to add a negative value to the pot" do
    assert_raise_message "Can only add positive values", ArgumentError do
      @pot.add -0.50
    end
  end

  test "should be able to add money to the pot" do
    assert_equal 5, @pot.add(5).value
  end

  test "should be able to add money with decimals to the pot" do
    assert_equal 5.75, @pot.add(5.75).value
  end

  test "should be able to perform compound addtion operations" do
    assert_equal 6.25, @pot.add(2).add(2.25).add(2).value
  end

  test "should return a string representation of the pot" do
    assert_equal "Pot: $300.00", @pot.add(300.00).to_s
  end

end
