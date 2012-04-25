
## Suits and Ranks


### Suits
A complete deck of 52 cards will contain exactly four different suits - spades, hearts, clubs and diamonds. Each suit instance along with the equivalent character value are shown below:

    Suit::SPADE    // 'S'
    Suit::HEART    // 'H'
    Suit::CLUB     // 'C'
    Suit::DIAMOND  // 'D'
    
    
### Ranks  
A complete deck of 52 cards will contain exactly thirteen ranks - numerical values 2 -> 10 inclusive, plus four non-numerical cards (Jack, Queen, King, Ace). Instances along with equivalent character values are shown below:
  
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
A playing card is constructed with one suit and one rank. A card can be created in by using the Suit and Rank classes as described above, or their equivalent character values.

    # Example 1: Creating a card with Rank and Suit instances.
    card = Card.new Rank::ACE, Suit::SPADE
    
    # Example 2: Creating a card with rank and suit values.
    card = Card.new "AS"
    
    # Example 3: Rank and suit values are case insensitive.
    card = Card.new "as"

### Creating multiple cards at once

You can create multiple cards at once by using the to_cards class method. The to_cards takes a series suit-rank characters seperated by commas or white spaces and returns an Array of Cards.

    # Example 1: Create an array of cards by providing a comma-seperated string.
    cards = Card.to_cards "AS,KS,QS,JS"
    
    # Example 2: Create an array of cards by providing a space-sepearated string.
    cards = Card.to_cards "AS KS QS JS"
    
    # Example 3: Rank and suit values are case insensitive.
    cards = Card.to_cards "as KS qs Js Ts"
    
## Hands

### Overview
A hand consists of exactly five cards, and can be constructed by providing an Array of cards or an equivalent sequence of suit-rank character values.

    # Example 1: Creating a hand with a comma-seperated string.
    hand = Hand.new "AS,KS,QS,JS,TS"
    
    # Example 2: Creating a hand with a space-seperated string.
    hand = Hand.new "AS KS QS JS TS"
    
    # Example 3: Creating a hand with an Array of cards.
    hand = Hand.new [Card.new("AS"), Card.new("KS"), Card.new("QS"), Card.new("JS"), Card.new("TS")]
    
    # Example 4: Creating a hand with an Array of cards, using Card.to_cards
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
    puts seven_high.probability => 0.50    // Probability of receiving any High Card
    
### Hand Detection    
    
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
    
## Starting Hands

Beyond the code samples presented below, the following links provide more information about [texas hold'em starting hands](http://www.moralesce.com/2012/01/21/holdem-starting-hands/) and [poker hand evaluation](http://www.moralesce.com/2011/11/26/poker-hand-evaluation/).

### Overview
A starting hand is also referred to as a players pocket cards, or hole cards. A starting hand consists of exactly two cards held by one player, unseen by opponents. Starting hands can be created by proiding an Array of Cards of an equivalent sequence of suit-rank character values.

    # Example 1: Creating a starting hand with a comma-seperated string.
    starting_hand = StartingHand.new "AS,KS"
    
    # Example 2: Creating a starting hand with a space-seperated string.
    starting_hand = StartingHand.new "AS KS"
    
    # Example 3: Creating a hand with an Array of cards.
    starting_hand = StartingHand.new [Card.new("AS"), Card.new("KS")]
    
    # Example 4: Creating a starting hand with an Array of cards, using Card.to_cards
    starting_hand = StartingHand.new Card.to_cards("AS,KS")
   
### Creating an array of all starting hands

    # Returns an array of all 1324 starting hands.
    all = StartingHand.all_starting_hands
    
    
### Creating an array of unique starting hands

    # Returns an array of 169 unique starting hands
    unique = StartingHand.unique_starting_hands