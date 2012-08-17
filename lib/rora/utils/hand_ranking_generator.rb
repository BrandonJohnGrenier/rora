require 'date'

class HandRankingGenerator
  
  def initialize
    @total = 133784560
    @count = 0
    @scores = {}
  end

  def generate_non_flush_hand_rankings
    file = File.new("non_flush_hand_rankings.csv", "w")
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
                    file.write("#{hand.score},#{key},#{ranks(hand.cards)},#{ranks(cards)},#{hand.type.key},#{hand.name}\n")
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

  def generate_flush_rankings
    file = File.new("flush_hand_rankings.csv", "w")
    Suit.values().each do |suit|
      generate_hand_rankings(suit, 5, 2, file)
      generate_hand_rankings(suit, 6, 1, file)
      generate_hand_rankings(suit, 7, 0, file)
    end
    file.close
  end

  def generate_hand_rankings(suit, i, j, file)
    Deck.new.retain_all(suit).combination(i).each do |suited|
      Deck.new.remove_all(suit).combination(j).each do |remainder|
        cards = suited + remainder
        hand = get_best_hand(cards)
        key = get_key(cards, hand)
        if(!@scores.has_key?(key))
          @scores[key] = hand.score
          file.write("#{hand.score},#{key},#{ranks(hand.cards)},#{ranks(cards)},#{hand.type.key},#{hand.name}")
        end
        @count = @count + 1
        if(@count % 50000 == 0)
          puts "#{DateTime.now.strftime('%Y-%m-%d %H:%M:%S')} :: #{@count} records processed, #{@scores.size} records captured"
        end
      end
    end
  end

  private

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