class HandRankingGenerator
  
  def initialize
    @scores = {}
  end

  def file_verification
    five_card = Hash.new
    CSV.foreach("lib/rora/5-card-hands.csv") do |row|
      five_card[row[0].to_i] = [row[1],row[2],row[3],row[4]]
    end

    seven_card = Hash.new
    CSV.foreach("lib/rora/7-card-hands.csv") do |row|
      seven_card[row[0].to_i] = [row[1],row[2],row[3],row[4]]
    end

    count = 0
    flush_count = 0
    five_card.each_pair do |key,value|
      if(!seven_card.has_key?(key))
        if(!value[3].include?("Flush"))
          puts "7 card hand ranking missing key #{key} { #{value[1]} => #{value[3]} }"
          count = count + 1
        else
          flush_count = flush_count + 1
        end
      end
    end
    puts "Summary: #{count} 7-card hands are not included in 5-card ranking. #{flush_count} flush cards unnacounted for"
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
                    if(!@scores.has_key?(key))
                      @scores[key] = hand.score
                      puts "#{key},#{hand.score}"
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
      # generate_hand_rankings(suit, 5, 2)
      generate_hand_rankings(suit, 6, 1)
      # generate_hand_rankings(suit, 7, 0)
    end
  end

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
    puts "found #{collisions} #{suit.value} collisions"
  end

  def rank_string(cards)
    cards.inject('') { |string, card| string << card.key }
  end

  def get_key(cards)
    key = cards.inject(1) {|product, card| product * card.rank.id }
  end

  def get_flush_key(cards, count)
    key = cards.inject(1) {|product, card| product * card.rank.id }
    cid = cards.inject(1) {|summand, card| summand * card.id }
    "#{key}-#{cid}"    
    
#    suit_key = cards.inject(0) {|sum, card| sum + card.suit.id }
#    rank_key = cards.inject(1) {|product, card| product * card.rank.id }
#    key = rank_key + suit_key
    #    if(count == 5)
    #      return key * 71
    #    end
    #    if(count == 6)
    #      return key * 73
    #    end
    #    if(count == 7)
    #      return key * 79
    #    end
  end

  def get_best_hand(cards)
    hands = []
    cards.combination(5).to_a.each { |selection| hands << Hand.new(selection) }
    hands.sort {|x,y| x.score <=> y.score }[0]
  end

end