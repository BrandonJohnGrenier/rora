require 'date'

class HandRankingGenerator

  HEART_FLUSH=32
  DIAMOND_FLUSH=243
  SPADE_FLUSH=3125
  CLUB_FLUSH=16807
  
  def initialize
    @total = 133784560
    @count = 0
    @scores = {}
  end

  def generate_flush_map
    file = File.new("flushes.csv", "w")

    Suit.values().each do |suit_1|
      Suit.values().each do |suit_2|
        Suit.values().each do |suit_3|
          Suit.values().each do |suit_4|
            Suit.values().each do |suit_5|
              Suit.values().each do |suit_6|
                Suit.values().each do |suit_7|
                  key = suit_1.id * suit_2.id * suit_3.id * suit_4.id * suit_5.id * suit_6.id * suit_7.id
                  if(!@scores.has_key?(key))
                    @scores[key] = key
                    suit = flush_suit(key)
                    if(!suit.nil?)
                      count = flush_count([suit_1, suit_2, suit_3, suit_4, suit_5, suit_6, suit_7], suit)
                      file.write("#{key},#{count},#{suit}\n")
                    end
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

  def generate_non_flush_hand_rankings
    file = File.new("7_card_non_flush_hands.csv", "w")
    cds = Deck.new.cards

    (0..45).each do |index_1|
      ((index_1 + 1)..46).each do |index_2|
        ((index_2 + 1)..47).each do |index_3|
          ((index_3 + 1)..48).each do |index_4|
            ((index_4 + 1)..49).each do |index_5|
              ((index_5 + 1)..50).each do |index_6|
                ((index_6 + 1)..51).each do |index_7|
                  cards = [cds[index_1], cds[index_2], cds[index_3], cds[index_4], cds[index_5], cds[index_6], cds[index_7]].sort
                  hand = get_best_hand(cards)
                  key = get_key(cards, hand)
                  if(!@scores.has_key?(key) && !hand.flush?)
                    @scores[key] = hand.score
                    file.write("#{hand.score},#{key}\n")
                  end
                  @count = @count + 1
                  if(@count % 1000 == 0)
                    puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} :: #{@count} records processed #{sprintf("%05.3f", (Float(@count)/Float(@total)) * 100.0)}% complete, #{@scores.size} records captured"
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

  def generate_flush_hand_rankings
    file = File.new("7_card_flush_hands.csv", "w")
    Suit.values().each do |suit|
      generate_hand_rankings(suit, 6, 1, file)
      generate_hand_rankings(suit, 7, 0, file)
    end
    file.close
  end

  private

  def generate_hand_rankings(suit, i, j, file)
    Deck.new.retain_all(suit).combination(i).each do |suited|
      Deck.new.remove_all(suit).combination(j).each do |remainder|
        cards = suited + remainder
        hand = get_best_hand(cards)
        key = get_key(cards, hand)
        if(!@scores.has_key?(key))
          @scores[key] = hand.score
          file.write("#{hand.score},#{key}")
        end
        @count = @count + 1
        if(@count % 1000 == 0)
          puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} :: #{@count} records processed, #{@scores.size} records captured"
        end
      end
    end
  end

  def flush_count(suits, suit)
    count = 0
    suits.each do |s|
      count = count + 1 if s.key == suit
    end
    count
  end

  def flush_suit(key)
    return "H" if(key % HEART_FLUSH == 0)
    return "D" if(key % DIAMOND_FLUSH == 0)
    return "S" if(key % SPADE_FLUSH == 0)
    return "C" if(key % CLUB_FLUSH == 0)
  end

  def get_key(cards, hand)
    cards.inject(1) {|product, card| product * (hand.flush? ? card.uid : card.rank.id) }
  end

  def ranks(cards)
    cards.inject('') { |string, card| string << card.rank.key }
  end

  def get_best_hand(cards)
    cards.combination(5).to_a.each.collect { |selection| Hand.new(selection) }.sort {|x,y| x.score <=> y.score }[0]
  end

end