require File.expand_path("../../rora_test", File.dirname(__FILE__))

class HandRankingGeneratorTest < ActiveSupport::TestCase

  def setup
    @generator = HandRankingGenerator.new
  end

  test "should generate flush rankings" do
    #@generator.generate_flush_rankings
  end

end
