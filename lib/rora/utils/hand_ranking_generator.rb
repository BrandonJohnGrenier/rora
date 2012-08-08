require 'date'

class HandRankingGenerator
  
  def initialize
    @total = 133784560
    @count = 0
    @scores = {}
  end

  def generate_7_card_hand_rankings
    file = File.new("7CH.csv", "w")

    Deck.new.combination(1).each do |card_1|
      Deck.new.remove(card_1).combination(1).each do |card_2|
        Deck.new.remove(card_1).remove(card_2).combination(1).each do |card_3|
          Deck.new.remove(card_1).remove(card_2).remove(card_3).combination(1).each do |card_4|
            Deck.new.remove(card_1).remove(card_2).remove(card_3).remove(card_4).combination(1).each do |card_5|
              Deck.new.remove(card_1).remove(card_2).remove(card_3).remove(card_4).remove(card_5).combination(1).each do |card_6|
                Deck.new.remove(card_1).remove(card_2).remove(card_3).remove(card_4).remove(card_5).remove(card_6).combination(1).each do |card_7|
                  cards = (card_1 + card_2 + card_3 + card_4 + card_5 + card_6 + card_7).sort
                  hand = get_best_hand(cards)
                  key = get_key(cards, hand)
                  if(!@scores.has_key?(key))
                    @scores[key] = hand.score
                    file.write("#{hand.score},#{key},#{rank_string(hand.cards)},#{rank_string(cards)},#{hand.type.key},#{hand.name}\n")
                  end
                  @count = @count + 1
                  if(@count % 50000 == 0)
                    puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} :: #{@count} rounds done, #{sprintf("%05.3f", (Float(@count)/Float(@total)) * 100.0)}% complete"
                  end
                end
              end
            end
          end
        end
      end
    end

    file.close
  end

  private

  def get_key(cards, hand)
    cards.inject(1) {|product, card| product * (hand.flush? ? card.id : card.rank.id) }
  end

  def rank_string(cards)
    cards.inject('') { |string, card| string << card.rank.key }
  end

  def get_best_hand(cards)
    hands = cards.combination(5).to_a.each.collect { |selection| Hand.new(selection) }
    hands.sort {|x,y| x.score <=> y.score }[0]
  end

end