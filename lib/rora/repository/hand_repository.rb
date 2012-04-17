require 'csv'
require 'singleton'

class HandRepository
  include Singleton
  attr_reader :table

  def initialize
    @table = Hash.new
    CSV.foreach("lib/rora/hands.csv") do |row|
      @table[row[1].to_i] = [row[0].to_i, row[3], row[4], row[5].to_f]
    end
  end

  def lookup id
    @table.fetch id
  end
end
