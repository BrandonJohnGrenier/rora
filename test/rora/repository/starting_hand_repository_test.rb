require File.expand_path("../../rora_test", File.dirname(__FILE__))

class StartingHandRepositoyTest < ActiveSupport::TestCase

  def setup
    @repository = StartingHandRepository.instance
  end

  test "should return all starting hands" do
    assert_equal 1326, @repository.all_starting_hands.size
  end

  test "should return distinct starting hands" do
    assert_equal 169, @repository.distinct_starting_hands.size
  end

end
