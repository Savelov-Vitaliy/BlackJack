class Deck

  def initialize    
    cards = (2..10).to_a + ['J', 'Q', 'K', 'A']
    suits = ['♠', '♥', '♣', '♦']   
    @deck = []
    suits.each  do |suit| 
      cards.each { |card| @deck << card.to_s + suit }    
    end
    @deck.shuffle!
  end

  def get_card
    @deck.delete(@deck.sample(1).join)     
  end

end
