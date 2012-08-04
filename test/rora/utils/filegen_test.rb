require File.expand_path("../../rora_test", File.dirname(__FILE__))

class FilegenTest < ActiveSupport::TestCase

  test "should return equity calculations for a heads up game" do
    Filegen.new.generate_non_flush_rankings
  end

end
