class BlackJack
  include PointsCounter
  include GetPlayerAnswer

  BET = 10

  def initialize
    puts "Welcome to BlackJack game. Let`s start!"
    print "Input your name: "
    @player = Player.new( gets.chomp.capitalize )
    @dealer = Player.new('Dealer')    
    start_new_game
  end

  def start_new_game
    puts ""
    puts "New game"
    reset
    @player.account = 100
    @dealer.account = 100  
    print_accounts
    deal
  end

  def reset
    @bank = 0
    @player.cards = []
    @dealer.cards = [] 
    @deck = Deck.new
  end

  def deal     
    puts ""
    puts "New deal" 
    bets 
    print "Bet: $#{BET}. Bank: $#{@bank}. "
    print_accounts   
    
    2.times { @player.cards << @deck.get_card }
    2.times { @dealer.cards << @deck.get_card }
  
    while @player.cards.size < 3 && @dealer.cards.size < 3  do        
      player_move ? break : dealer_move
    end
  
    open_cards 

    if play_again? 
      game_over? ?  start_new_game : continue_game 
    else
      puts ""
      puts "Goodbye" 
    end
  end

  def continue_game
    reset
    deal
  end
  
  def bets    
    @player.account -= BET
    @dealer.account -= BET
    @bank += BET * 2
  end

  def game_over?
    (@player.account <= 0 || @dealer.account <= 0) ? true : false
  end

  def play_again?
    puts ""
    print "Play again? (y/n):"
    get_player_answer('y', 'n') == 'y' ? true : false
  end

  def player_move
    puts ""
    puts "#{@player.name} move:"
    print_dealer_cards
    print_player_cards
    print "What to do? (1 - hit, 2 - stand, 3 - open) : "    
    case get_player_answer('1', '2', '3')
      when '1' 
        @player.cards << @deck.get_card if @player.cards.size < 3
        print_player_cards
      when '3'
        return true
      end
      false
  end

  def dealer_move    
    puts ""
    puts "#{@dealer.name} move:"
    @dealer.cards << @deck.get_card if get_points(@dealer.cards) < 17 && @dealer.cards.size < 3
    print_dealer_cards
  end

  def open_cards
    puts ""
    puts "Open cards:"
    print_dealer_cards(true)
    print_player_cards
    puts ""
    winner = get_winner
    unless winner.to_s.empty? 
      winner = instance_variable_get(winner)
      print "#{winner.name} win! "          
      winner.account += @bank        
    else 
      print "Draw! "
      @player.account += @bank / 2
      @dealer.account += @bank / 2        
    end  

    print_accounts     
  end

  def print_accounts
    puts "#{@player.name}: $#{@player.account}, #{@dealer.name}: $#{@dealer.account}" 
  end

  def print_dealer_cards(open = false)    
    print "Dealer cards: "
    print open ? "#{@dealer.cards.join ' '}." : "#{@dealer.cards.size} cards."
    puts open ? " Dealer points: #{get_points(@dealer.cards)}" : ""
  end

  def print_player_cards   
    puts "Yours cards: #{@player.cards.join ' '}. Yours points: #{get_points(@player.cards)}"
  end

  def get_winner
    dealer_points = get_points(@dealer.cards) 
    player_points = get_points(@player.cards)
    return nil if (player_points > 21 && dealer_points > 21) || player_points == dealer_points   
    return :@player if dealer_points > 21 
    return :@dealer if player_points > 21     
    return player_points > dealer_points ? :@player : :@dealer
  end

end
