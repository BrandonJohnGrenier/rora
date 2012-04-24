
### Suits and Ranks
A complete deck of 52 cards will contain exactly four different suits and thirteen different ranks. Instances along with equivalent character values are displayed below:

    Suit::SPADE    // 'S'
    Suit::HEART    // 'H'
    Suit::CLUB     // 'C'
    Suit::DIAMOND  // 'D'
    
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

### Cards
A playing card is constructed with one suit and one rank. A card can be created in by using the Suit and Rank classes as described above, or their equivalent character values.

    # Example 1: Creating a card with Rank and Suit instances.
    card = Card.new(Rank::ACE, Suit::SPADE)
    
    # Example 2: Creating a card with rank and suit values.
    card = Card.new("AS")
    
    # Example 3: Rank and suit values are case insensitive.
    card = Card.new("as")

You can create multiple cards at once by using the to_cards class method. The to_cards takes a series suit-rank characters seperated by commas or white spaces and returns an Array of Cards.

    # Example 1: Create an array of cards by providing a comma-seperated string.
    cards = Card.to_cards "AS,KS,QS,JS"
    
    # Example 2: Create an array of cards by providing a space-sepearated string.
    cards = Card.to_cards "AS KS QS JS"
    
    # Example 3: Rank and suit values are case insensitive.
    cards = Card.to_cards "as KS qs Js Ts"
    
### Hands
A hand consists of exactly five cards, and can be constructed by providing an Array of cards or a sequence of suit-rank character values.

    # Example 1: Creating a hand with a comma-seperated string.
    hand = Hand.new "AS,KS,QS,JS,TS"
    
    # Example 2: Creating a hand with a space-seperated string.
    hand = Hand.new "AS KS QS JS TS"
    
    # Example 3: Creating a hand with an Array of cards.
    hand = Hand.new [card1, card2, card3, card4, card5]
    
    # Example 4: Creating a hand with an Array of cards, using Card.to_cards
    hand = Hand.new(Card.to_cards("AS,KS,QS,JS,TS"))
    
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
    
You can query a hand to determine what kind of hand it is.

    # Example 1: Testing for a straight flush
    puts Hand.new("AS,KS,QS,JS,TS").straight_flush? => true
    puts Hand.new("AS,KS,QS,JS,TS").two_pair? => false
    