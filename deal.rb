class Deal

  attr_accessor :bet, :bank

  def initialize(players)
    @players = players
    @deck = Deck.new
    @players.each do |key, player| 
      player.cards = []
      2.times { player.cards << @deck.get_card } 
    end
    @bank = 0
    @bet = 10
    bets
  end

  def bets    
    @players.each do |key, player| 
      player.account -= @bet 
      @bank += @bet 
    end
  end

   def cards_oveflow?
    oveflow = true
    @players.each { |key, player| oveflow &= player.cards.size >= 3 }
    oveflow
  end

  def winner
    winner = get_winner
    unless winner.to_s.empty? 
      winner.account += @bank 
      winner = winner.name
    else 
      @players.each { |key, player| player.account += @bank / 2 }
      winner = "draw! "   
    end 
    winner  
  end

  def get_winner
    player_points = get_points(@players[:player].cards) 
    dealer_points = get_points(@players[:dealer].cards)
    return nil if (player_points > 21 && dealer_points > 21) || player_points == dealer_points   
    return @players[:player] if dealer_points > 21 
    return @players[:dealer] if player_points > 21     
    return player_points > dealer_points ? @players[:player] : @players[:dealer]
  end

  def take_card(player, ai = false)    
    ai == :ai ? additional_condition = get_points(player.cards) < 17 : additional_condition = true
    player.cards << @deck.get_card if player.cards.size < 3 && additional_condition
  end

  def reset
    @bank = 0
    @player.cards = []
    @dealer.cards = [] 
    @deck = Deck.new
  end

  def get_points(cards)
    points = 0
    aces = cards.find_all { |card| card[0] == 'A' }
    cards -= aces    
    cards.each { |card| ['J', 'Q', 'K' ].include?(card[0]) ? points +=10 : points += card[0..-2].to_i }
    aces.each { |ace| points + 11 <= 21 ? points += 11 : points += 1 } unless aces.empty?
    points
  end

end
