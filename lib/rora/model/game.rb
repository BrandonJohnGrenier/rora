class Game
  attr_reader :table, :buy_in, :started

  def initialize arguments=nil
    @table = arguments.nil? ? Table.new : (arguments[:table].nil? ? Table.new : arguments[:table])
    @buy_in = arguments.nil? ? 50 : (arguments[:buy_in].nil ? 20 : arguments[:buy_in])
    @log = GameLogger.new
    @started = false
  end

  def start
    @started = true
  end

  def add player
    raise ArgumentError, "#{player.name} cannot join game, stack of #{player.stack} is less than the buy in amount #{@buy_in}" if player.stack < @buy_in
    raise ArgumentError, "#{player.name} cannot join game, the game has already started" if @started
    player.join_game self
  end

  def remove player
    player.leave_game
  end

  def pot
    @table.pot
  end

  def shuffle_deck
    @log.debug("Shuffling the deck")
    @table.deck.shuffle
  end

  def assign_button
    @table.pass_the_buck
    @log.info("#{@table.the_button.player.name} will be the dealer for this hand");
  end

  def post_small_blind
    @table.the_small_blind.player.post_small_blind
    @log.info("#{@table.the_small_blind.player.name} posts the small blind");
  end

  def post_big_blind
    @table.the_big_blind.player.post_big_blind
    @log.info("#{@table.the_big_blind.player.name} posts the big blind");
    @log.info("The pot is at #{@table.pot.value}");
  end

  def deal_pocket_cards
    @table.players.each do |player|
      player.add table.deck.deal
    end
    @table.players.each do |player|
      player.add table.deck.deal
    end
  end

  def place_bet amount
    @table.pot.add amount
  end

  def run_preflop_betting_round
    @log.info("-----------------------------------------------------------------")
    first_to_act = @table.under_the_gun
    first_to_act.player.act
    number = first_to_act.number
    seat_number = @table.the_seat_after(first_to_act).number

    while seat_number != number
      @table.seat[(seat_number - 1)].player.act
      seat_number = @table.the_seat_after(@table.seat[(seat_number - 1)]).number
    end
  end

end
