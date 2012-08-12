require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandRankingGeneratorTest < ActiveSupport::TestCase

  def setup
    @generator = HandRankingGenerator.new
  end

  test "should return equity calculations for a heads up game" do
    #@generator.generate_7_card_hand_rankings
  end

end
