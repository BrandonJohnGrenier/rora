class Filegen
  def initialize
    @scores = {}
  end

  def begin
    Suit.values().each do |suit|
      generate_hand_rankings(suit, 5, 2)
      generate_hand_rankings(suit, 6, 1)
      generate_hand_rankings(suit, 7, 0)
    end

    # file = File.open("7CH.csv", "w")
    # @scores.each {|key, value| file.write("#{key},#{value}") }
    # file.close
  end

  def generate_hand_rankings(suit, i, j)
    Deck.new().retain_all(suit).combination(i).each do |suited|
      Deck.new().discard_all(suit).combination(j).each do |remainder|
        cards = suited + remainder
        @scores[get_key(cards)] = get_best_hand(cards)
      end
    end
  end

  def get_key(cards)
    key = 1
    cards.each do |card|
      key *= card.id
    end
    key
  end

  def get_best_hand(cards)
    hands = []
    cards.combination(5).to_a.each { |selection| hands << Hand.new(selection) }
    hands.sort {|x,y| x.score <=> y.score }[0]
  end

end