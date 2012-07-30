class Filegen

  def initialize
    @scores = {}
  end

  def generate_non_flush_rankings
    Deck.new.combination(1).each do |card_1|
      Deck.new.remove(card_1).combination(1).each do |card_2|
        Deck.new.remove(card_1).remove(card_2).combination(1).each do |card_3|
          Deck.new.remove(card_1).remove(card_2).remove(card_3).combination(1).each do |card_4|
            Deck.new.remove(card_1).remove(card_2).remove(card_3).remove(card_4).combination(1).each do |card_5|
              Deck.new.remove(card_1).remove(card_2).remove(card_3).remove(card_4).remove(card_5).combination(1).each do |card_6|
                Deck.new.remove(card_1).remove(card_2).remove(card_3).remove(card_4).remove(card_5).remove(card_6).combination(1).each do |card_7|
                  cards = card_1 + card_2 + card_3 + card_4 + card_5 + card_6 + card_7
                  key = get_key(cards)
                  hand = get_best_hand(cards)
                  if(!hand.flush?)
                    raise RuntimeError, "Key collision for key #{key}, two different hand scores: #{@scores[key]} vs #{hand.score}" if(@scores.has_key?(key) && hand.score != @scores[key])
                    puts "#{key},#{hand.score}"
                    @scores[key] = hand.score
                    if(@scores.size >= 6150)
                      puts "Generated all 6150 7-card (non-flush) hands"
                      return
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def generate_flush_rankings
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
    Deck.new.retain_all(suit).combination(i).each do |suited|
      Deck.new.remove_all(suit).combination(j).each do |remainder|
        cards = suited + remainder
        @scores[get_flush_key(cards)] = get_best_hand(cards)
      end
    end
  end

  def get_key(cards)
    cards.inject(1) {|product, card| product * card.rank.id }
  end

  def get_flush_key(cards)
    cards.inject(1) {|product, card| product * card.id }
  end

  def get_best_hand(cards)
    hands = []
    cards.combination(5).to_a.each { |selection| hands << Hand.new(selection) }
    hands.sort {|x,y| x.score <=> y.score }[0]
  end

end