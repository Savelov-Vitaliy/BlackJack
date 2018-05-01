class GameInterface

  def initialize
    puts "Welcome to BlackJack game. Let`s start!"
    print "Input your name: "    
    @game = BlackJack.new(gets.chomp.capitalize)
    start_new_game
  end

  def start_new_game    
    @game.start_new_game 
    puts ""
    puts "New game"       
    print_accounts
    deal
  end

  def deal 
    @deal = @game.new_deal   
    @payer_stands = 0 
    puts ""
    puts "New deal"      
    puts "Bet: $#{@deal.bet}. Bank: $#{@deal.bank}. "
    print_accounts      
    while !@deal.cards_oveflow? && @payer_stands < 2 do 
      player_move ? break : dealer_move 
    end
    open_cards

    if play_again? 
      @game.game_over? ?  start_new_game : deal 
    else
      puts ""
      puts "Goodbye" 
    end
  end  

  def play_again?
    puts ""
    get_player_answer("Play again?", {'y' => 'y/', 'n' => 'n'}) == 'y' ? true : false
  end

  def player_move
    player = @game.players[:player]
    dealer = @game.players[:dealer]
    puts ""
    puts "#{player.name} move:"
    print_cards(dealer, false)
    print_cards(player)  
    answers = {}
    answers["1"] = "1 - hit, " if player.cards.size < 3
    answers["2"] = '2 - stand, ' if @payer_stands < 2 
    answers["3"] = '3 - open'
    case get_player_answer("What to do?", answers)
      when '1' 
        @deal.take_card(player)
        print_cards(player)
        @payer_stands = 0
      when '2'
        @payer_stands += 1
      when '3'
        return true
      end
      false
  end

  def dealer_move   
    dealer = @game.players[:dealer]
    puts ""
    puts "#{dealer.name} move:"
    @deal.take_card(dealer, :ai)
    print_cards(dealer, false)
  end

  def open_cards
    puts ""
    puts "Open cards:"
    print_cards(@game.players[:dealer]) 
    print_cards(@game.players[:player]) 
    puts ""
    puts "Winner: #{@deal.winner}" 
    print_accounts     
  end

  def print_accounts
    @game.players.each { |key, player| print "#{player.name}: $#{player.account}. " }
    puts ""
  end

  def print_cards(player, open = true)
    print "#{player.name} cards: "    
    print open ? "#{player.cards.join ' '}, " : "#{player.cards.size} cards. "
    puts open ? " points: #{@deal.get_points(player.cards)}" : ""
  end

  def get_player_answer(question, *param)  
    print question + " ("
    param[0].each { |answer, hint| print hint }
    print ") : "
    input = ""  
    loop do 
      input = gets.chomp.to_s
      break if param[0].include? input
      print "Incorrect answer. Try again: "
    end      
    input
  end

end
