class HandRankingGenerator

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
                  cards = (card_1 + card_2 + card_3 + card_4 + card_5 + card_6 + card_7).sort
                  key = get_key(cards)
                  hand = get_best_hand(cards)
                  if(!hand.flush? && !@scores.has_key?(key))
                    @scores[key] = hand.score
                    puts "#{hand.score},#{key},#{rank_string(hand.cards)},#{rank_string(cards)},#{hand.type.key},#{hand.name}"
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
  end

  private

  def generate_hand_rankings(suit, i, j)
    collisions = 0
    Deck.new.retain_all(suit).combination(i).each do |suited|
      Deck.new.remove_all(suit).combination(j).each do |remainder|
        cards = suited + remainder
        key = get_flush_key(cards, i)
        hand = get_best_hand(cards)
        if(@scores.has_key?(key) && hand.score != @scores[key])
          collisions = collisions + 1
          puts "ERROR ==> #{hand.score},#{key},#{rank_string(hand.cards)},#{rank_string(cards)},#{hand.type.key},#{hand.name}"
          #raise RuntimeError, "Key collision for key #{key}, two different hand scores: #{@scores[key]} vs #{hand.score} #{cards}"
        end
        if(!@scores.has_key?(key))
          @scores[key] = hand.score
          puts "#{hand.score},#{key},#{rank_string(hand.cards)},#{rank_string(cards)},#{hand.type.key},#{hand.name}"
        end
      end
    end
  end

  def get_flush_key(cards, count)
    key = cards.inject(1) {|product, card| product * card.rank.id }
    cid = cards.inject(1) {|summand, card| summand * card.id }
  end

  def rank_string(cards)
    cards.inject('') { |string, card| string << card.rank.key }
  end

  def get_key(cards)
    key = cards.inject(1) {|product, card| product * card.rank.id }
  end

  def get_best_hand(cards)
    hands = []
    cards.combination(5).to_a.each { |selection| hands << Hand.new(selection) }
    hands.sort {|x,y| x.score <=> y.score }[0]
  end

end