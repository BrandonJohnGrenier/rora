[![Build Status](https://secure.travis-ci.org/BrandonJohnGrenier/rora.png?branch=master)](http://travis-ci.org/BrandonJohnGrenier/rora)


# About Rora

Rora is a Ruby library for conducting poker experiments and simulations.



# Rora Domain Model


## Suits and Ranks


### Suits
A complete deck of 52 cards will contain exactly four different suits - spades, hearts, clubs and diamonds. Each suit instance along with the equivalent character value are shown below:

    Suit::SPADE    // 'S'
    Suit::HEART    // 'H'
    Suit::CLUB     // 'C'
    Suit::DIAMOND  // 'D'
    
    
### Ranks  
A complete deck of 52 cards will contain exactly thirteen ranks - the numerical values 2 through 10 (inclusive), plus four non-numerical cards (Jack, Queen, King, Ace). Instances along with equivalent character values are shown below:
  
    Rank::ACE      // 'A'
    Rank::KING     // 'K'
    Rank::QUEEN    // 'Q'
    Rank::JACK     // 'J'
    Rank::TEN      // 'T'
    Rank::NINE     // '9'
    Rank::EIGHT    // '8'
    Rank::SEVEN    // '7'
    Rank::SIX      // '6'
    Rank::FIVE     // '5'
    Rank::FOUR     // '4'
    Rank::THREE    // '3'
    Rank::TWO      // '2'

## Cards

### Overview
A playing card is constructed with exactly one suit and one rank. A card can be created  by using the Suit and Rank classes as described above, or their equivalent character values.

    # Example 1: Creating a card with Rank and Suit instances.
    card = Card.new Rank::ACE, Suit::SPADE
    
    # Example 2: Creating a card with rank and suit values.
    card = Card.new "AS"
    
    # Example 3: Rank and suit values are case insensitive.
    card = Card.new "as"

### Creating multiple cards at once

You can create multiple cards at once by using the to_cards class method. The to_cards takes a series suit-rank characters seperated by commas or white spaces and returns an array of cards.

    # Example 1: Create an array of cards by providing a comma-seperated string.
    cards = Card.to_cards "AS,KS,QS,JS"
    
    # Example 2: Create an array of cards by providing a space-sepearated string.
    cards = Card.to_cards "AS KS QS JS"
    
    # Example 3: Rank and suit values are case insensitive.
    cards = Card.to_cards "as KS qs Js Ts"
    
## Hands

### Overview
A hand consists of exactly five cards, and can be constructed by providing an array of cards or an equivalent sequence of suit-rank character values.

    # Example 1: Creating a hand with a comma-seperated string.
    hand = Hand.new "AS,KS,QS,JS,TS"
    
    # Example 2: Creating a hand with a space-seperated string.
    hand = Hand.new "AS KS QS JS TS"
    
    # Example 3: Creating a hand with an Array of cards.
    hand = Hand.new [Card.new("AS"), Card.new("KS"), Card.new("QS"), Card.new("JS"), Card.new("TS")]
    
    # Example 4: Creating a hand with an array of cards, using Card.to_cards
    hand = Hand.new Card.to_cards("AS,KS,QS,JS,TS")
    
### Hand Score  
    
Each hand in poker has a rank, or score. While many software libraries provide the capability to calculate hand scores, rora implicitly provides you with a score for each hand. 

    # Example 1: A Royal Flush is the highest scoring poker hand.
    royal_flush = Hand.new "AS,KS,QS,JS,TS"
    
    puts royal_flush.score => 1
    puts royal_flush.name => 'Royal Flush'
    puts royal_flush.probability => 0.0015  // Probability of receiving any Royal Flush
    
    # Example 2: A Seven-High High Card is the lowest scoring poker hand.
    seven_high = Hand.new "7S,5H,4H,3C,2C"
    
    puts seven_high.score => 7642
    puts seven_high.name => 'High Card'
    
### Hand Type Detection    
    
You can query a hand to determine what kind of hand it is.

    # Example 1: Testing for a straight flush
    puts Hand.new("AS,KS,QS,JS,TS").straight_flush? => true
    puts Hand.new("AS,KS,QS,JS,TS").two_pair? => false
    
Hand type detection extends to the following methods:    
    
- flush?
- straight_flush?
- four_of_a_kind?
- full_house?
- straight?
- three_of_a_kind?
- two_pair?
- one_pair?
- high_card?

### Hand Type Probability

You can query a hand to determine the probability of drawing that type of hand.

    # Example 1: Determine the probability of a Royal Flush
    puts Hand.new("AS,KS,QS,JS,TS").probability => 0.0015
    
## Starting Hands

Beyond the code samples presented below, the following links provide more information about [texas hold'em starting hands](http://www.moralesce.com/2012/01/21/holdem-starting-hands/) and [poker hand evaluation](http://www.moralesce.com/2012/07/26/a-5-card-poker-hand-evaluator-in-ruby).

### Overview
A starting hand is also referred to as a player's pocket cards, or hole cards. A starting hand consists of exactly two cards, and can be constructed by providing an array of cards or an equivalent sequence of suit-rank character values.

    # Example 1: Creating a starting hand with a comma-seperated string.
    starting_hand = StartingHand.new "AS,KS"
    
    # Example 2: Creating a starting hand with a space-seperated string.
    starting_hand = StartingHand.new "AS KS"
    
    # Example 3: Creating a hand with an Array of cards.
    starting_hand = StartingHand.new [Card.new("AS"), Card.new("KS")]
    
    # Example 4: Creating a starting hand with an Array of cards, using Card.to_cards
    starting_hand = StartingHand.new Card.to_cards("AS,KS")
   
### Creating an array of all starting hands

Given a deck of 52 cards, choosing any two card yields 1326 distinct 2 card combinations

    # Returns an array of all 1326 starting hands.
    all = StartingHand.all_starting_hands
    
    
### Creating an array of unique starting hands

    # Returns an array of 169 unique starting hands
    unique = StartingHand.unique_starting_hands
    
## Decks

### Overview
A deck consists of 52 playing cards.

    # Creates a new Deck
    deck = Deck.new
    
    # A new deck will have 52 playing cards
    cards = deck.cards
    puts cards.size => 52
    
    # You can also get size of the deck from the deck itself.
    puts deck.size => 52
    
### Shuffling and Dealing
When a deck is created the cards are well organized. The deck should be shuffled to randomize the order of the cards before they are dealt.
    
    # Shuffling the deck
    deck.shuffle
    
    # The deal method returns one card from the deck.
    puts deck.size => 52
    card = deck.deal 
    puts deck.size => 51
    
### Removing Cards
The remove method takes a variety of arguments.

    # Removes a single card from the deck
    deck.remove Card.new("AS")
    
    # Removes a single card from the deck
    deck.remove "AS"
    
    # Removes multiple cards from the deck
    deck.remove "AS,KS,QS,JS,TS"
    
    # Removes multiple cards from the deck
    deck.remove [Card.new("AS"), Card.new("KS"), Card.new("QS")]
    
    # Removes a starting hand from the deck
    starting_hand = StartingHand.new "AS, KS"
    deck.remove starting_hand
    
    # Removes all spades from the deck
    deck.remove_all Suit::SPADE
    
    # Removes all cards aside from spades
    deck.retain_all Suit::SPADE
    
    # Removes all kings from the deck
    deck.remove_all Rank::KING
    
    # Removes all cards aside from kings
    deck.retain_all Rank::KING
    
### Inspecting the Deck
You can query the deck to determine whether it contains a specific card or at least one card in a group.  
    
    # Determines if the Ace of Spades is in the deck.
    deck.contains "AS"
    
    # Determines if the Ace of Spades is in the deck.
    deck.contains Card.new("AS")
    
    # Determines if any Ace is in the deck.
    deck.contains_any "AS,AH,AD,AC"
    
     # Determines if any Ace is in the deck.
    deck.contains_any [Card.new("AS"), Card.new("AH"), Card.new("AD"), Card.new("AC")]
    
    # Determines if there are any cards in the deck
    deck.empty?
    
    # Returns the number of Aces left in the deck
    deck.count_cards_with_rank Rank::ACE
    
    # Returns the number of Clubs left in the deck
    deck.count_cards_with_suit Suit::CLUB
    
    
### Combinations
The combination method allows you to enumerate through card subsets. Given a combination value greater than 1, the method will return a two-dimensional array.

    # Chooses every possible 2 card combination from the deck. Assuming the deck contains 52
    # cards, this example will return 1326 2-card combinations.
    cards = deck.combination 2
    
    # Chooses every possible 5 card combination from the deck. Assuming the deck contains 52
    # cards, this example will return 2,598,960 5-card combinations.
    cards = deck.combination 5
    
## Boards

### Overview
A board represents the logical table area where community cards are dealt. A board can be setup with either 0, 3, 4 or 5 unique cards to represent and empty board, the flop, turn, or river (respectively).

    # Creates an empty board.
    board = Board.new
    
    # Creates a board with the flop.
    board = Board.new "AS,KS,QS"
    
    # Creates a board with the flop and turn.
    board = Board.new "KS,QS,JS,AS"
    
    # Create a board with the flop, turn and river cards.
    board = Board.new "KS,QS,7H,4C,3H"
    
### Subsequent Betting Rounds
An empty board can be populated after constrution as well - this is the most common usage.

    board = Board.new
    board.flop = "AS,KS,QS"
    board.turn = "4D"
    board.river = "3D"
    
    puts board.size => 5
    
### Inspecting the Board
You can query the board to determine whether it contains a specific card or at least one card in a group.

    # Determines if the Ace of Spades is on the board.
    board.contains Card.new("AS")    
    
    # Determines if the Ace of Spades is on the board.
    board.contains "AS"
    
    # Determines if any Ace is on the board.
    board.contains_any [Card.new("AS"), Card.new("AH"), Card.new("AD"), Card.new("AC")]
    
    # Determines if any Ace is on the board.
    board.contains_any "AS,AH,AD,AC"
    
    # You can query to the board for flop, turn and river cards.
    puts board.flop => '2H', '3C', 'JH'
    puts board.turn => 'AS'
    puts board.river => 'JS'
    
    # You can query the board to return all cards on the board
    puts board.cards => '2H', '3C', 'JH', 'AS', 'JS'
    
## Pots

### Overview

A pot represents the sum of money that players compete for during a hand of poker.

    # Creates a new pot.
    pot = Pot.new
    
### Adding Money to the Pot

You can add positive sums of money to the pot. At the moment the pot assumes only one kind of (implicit) currency.

    # Add money to the pot
    pot.add(5) 
    puts pot.value => '5'
    
    # Chain add operations
    pot.add(5).add(5).add(5)
    puts pot.value => '15'
    
    # Add decimal values to the pot
    pot.add(2.50).add(1.25)
    puts pot.value => '3.75'
    
    # The to_s representation returns formatted monetary amount
    pot.add(300)
    puts pot.to_s => '$300.00'

## Tables

### Overview

A poker table where players compete for pots. A newly created table will have one deck of 52 cards, one  pot with zero dollars and one empty board. You can specify the number of seats at the table - if not specified, a table will be created with 9 seats. A table must have a minimum of 2 seats.

    # Creates a table with 9 seats
    table = Table.new
    
    # Creates a table with 6 seats
    table = Table.new 6
    
### Swapping pots, boards and decks

You can provide a table with different decks, boards and pots. This configuration is chainable, as shown in the example below:

    deck = Deck.new
    pot = Pot.new
    board = Board.new
    …
    # Creates a table, and configures the table to use the specified board, pot and deck.
    table = Table.new
   	table.with(deck).with(board).with(pot)
   	
### Managing players
A poker table won't do us any good unless we have a few players sitting in on a game. We can add players to the table using the add method:
	
	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    
    # James will automatcially take seat number 1
    table.add james  
    
    # Sally will automatcially take seat number 2  
    table.add sally    
    
    # You can chain add calls together, like this:
    table.add(james).add(sally) 
    
At a real poker table, players are free to sit at any available seat at the table. You can specify which seat a player sits at:

	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    
    # james will sit at seat number 2
    table.add james 2  
    
    # sally will sit at seat number 6
    table.add sally 6  
    
This index is not zero based. In other words, seat 1 is the first seat, you cannot specify to sit at seat 0. If the specified seat is already taken by another player an exception is raised. If the specified seat doesn't exist (you specify to seat a player at seat 11 at a 9-seated table) and exception will be raised.    

You can remove players by using the tables' remove method: 

    # Create a table and a couple of players
	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    
    # james will automatcially take seat number 1
    table.add james  
    
    # james will be removed, seat number 1 will be free
    table.remove james
    
### Inspecting the table

    # Returns the number of seats at the table
    table.size

    # Determines if all of the seats at the table are occupied
    table.full?
    
    # Determines if none of the seats at the table are occupied
    table.empty?
    
    # Returns all players sitting at the table as an array
    table.players
    
    # Returns seat number 3
    third_seat = table.seat(3)
    
### Poker positions at the table

Rora makes it trivial to identify key positions at the poker table. The dealer, or 'button' is a rotating position - after every hand a new dealer is chosen by moving the 'button' or 'puck' in a clockwise fashion around the table.

    # Returns the seat with the button.
    table.the_button
    
    # Prints out the name of the player in the button
    puts table.the_button.player.name => 'John'
    
    # Automatically assigns the button to the next available player
    table.pass_the_buck

The small blind sits to the immediate left of the dealer, and is required to post one half sized bet before before a hand begins.

    # Returns the seat with the small blind.
    table.the_small_blind
    
    # In a heads up (2-player) game, the small blind is also the button
	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    table.add(james).add(sally)
    
    puts table.the_button.player.name => 'James'
    puts table.the_small_blind.player.name => 'James'
    
The big blind sits to the immediate left of the small blind, and must post one full sized bet before a hand begins.   
    
    # Returns the seat with the big blind.
    table.the_big_blind 
    
	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    table.add(james).add(sally)
    
    puts table.the_small_blind.player.name => 'James'
    puts table.the_big_blind.player.name => 'Sally'
    
    
Under the Gun (UTG) sits to the immediate left of the big blind, and is the first player to act in the pre-flop betting round. The player to the left the big blind is always the first player to act in the preflop betting round. In a heads up game, the small blind is also UTG.
    
    # Returns the seat that is first to act, or 'under the gun'
    table.under_the_gun   
    
    # In a heads up game, the small blind is also the first to act (under the gun)!
	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    table.add(james).add(sally)
    
    puts table.the_small_blind.player.name => 'James'
    puts table.the_big_blind.player.name => 'Sally'
    puts table.under_the_gun.player.name => 'James'
    

### Gaps in player positions
There is no need for players to sit directly beside each other. Rora maintains an internal linked list of players and their relative positions, so there can be gaps between seated players.

    # Create a table with three players
	table = Table.new
    james = Player.new("James")
    sally = Player.new("Sally")
    frank  = Player.new("Frank")
    
    # James will take seat 2, Sally will take seat 6, Frank will take seat 8
    # We have seating gaps between each player, no worries
    table.add james 2  
    table.add sally 6 
    table.add frank 8
    
    puts table.the_small_blind.player.name => 'James'
    puts table.the_big_blind.player.name => 'Sally'
    puts table.under_the_gun.player.name => 'Frank'
