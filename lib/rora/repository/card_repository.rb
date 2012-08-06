require 'csv'
require 'singleton'

class CardRepository
  include Singleton
  
  def initialize
    @card_table = Hash.new
    CSV.foreach("lib/rora/cards.csv") do |row|
      @card_table[row[0]] = row[1].to_i
    end
  end

  def get(key)
    @card_table.fetch(key)
  end
end