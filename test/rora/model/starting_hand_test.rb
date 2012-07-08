require File.expand_path("../../rora_test", File.dirname(__FILE__))

class StartingHandTest < ActiveSupport::TestCase

  test "should raise an error when a starting hand is not created with 2 cards" do
    assert_raise_message "Exactly 2 cards are required to create a starting hand, 3 provided", ArgumentError do
      StartingHand.new [Card.new("AS"), Card.new("KS"), Card.new("QS")]
    end
  end

  test "should raise an error when a starting hand is not created with 4 characters" do
    assert_raise_message "Exactly 2 cards are required to create a starting hand, 4 provided", ArgumentError do
      StartingHand.new "ASKSQSJS"
    end
  end

  test "should raise an error when creating a starting hand with duplicate cards" do
    assert_raise_message "The starting hand contains duplicate cards", ArgumentError do
      StartingHand.new "ASAS"
    end
  end

  test "the starting hand should not be suited" do
    assert_equal false, StartingHand.new("JHTS").suited?
  end

  test "the starting hand should be suited" do
    assert_equal true, StartingHand.new("JHTH").suited?
  end

  test "the starting hand should have a value" do
    assert_equal "AS,KS", StartingHand.new("ASKS").value
  end

  test "the starting hand should have a short value" do
    assert_equal "AKs", StartingHand.new("ASKS").short_value
  end

  test "the hand should have a pocket pair" do
    assert_equal true, StartingHand.new("ASAH").pocket_pair?
  end

  test "the hand should not have a pocket pair" do
    assert_equal false, StartingHand.new("ASKH").pocket_pair?
  end

  test "the starting hand should have an id that is equal to the product of the card ids" do
    assert_equal StartingHand.new("ASKH").id, (Card.new("AS").id * Card.new("KH").id)
  end

  test "the starting hand should have a key that is equal to the product of the card rank ids when the starting hand is unsuited" do
    assert_equal StartingHand.new("ASKH").key, (Card.new("AS").rank.id * Card.new("KH").rank.id)
  end

  test "the starting hand should have a key that is equal to 67 times the product of the card rank ids when the starting hand is suited" do
    assert_equal StartingHand.new("ASKS").key, (Card.new("AS").rank.id * Card.new("KS").rank.id * 67)
  end

  test "should return all starting hands" do
    assert_equal 1326, StartingHand.all_starting_hands.size
  end

  test "should return distinct starting hands" do
    assert_equal 169, StartingHand.distinct_starting_hands.size
  end

end
