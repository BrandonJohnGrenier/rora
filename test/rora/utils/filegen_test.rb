require File.expand_path("../../rora_test", File.dirname(__FILE__))

class FilegenTest < ActiveSupport::TestCase
  
  def setup
    @board = Board.new
  end

  test "should return equity calculations for a heads up game" do
    Filegen.new.begin
  end

end
