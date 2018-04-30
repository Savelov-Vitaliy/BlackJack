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
    puts ""
    puts "New deal"      
    print "Bet: $#{@deal.bet}. Bank: $#{@deal.bank}. "
    print_accounts      

    while !@deal.cards_oveflow? do 
      player_move ? break : dealer_move 
    end
    open_cards

    if play_again? 
      @game.game_over? ?  start_new_game : continue_game 
    else
      puts ""
      puts "Goodbye" 
    end
  end

  def continue_game
    @deal = @game.new_deal
    deal
  end

  def play_again?
    puts ""
    print "Play again? (y/n):"
    get_player_answer('y', 'n') == 'y' ? true : false
  end

  def player_move
    player = @game.players[:player]
    dealer = @game.players[:dealer]
    puts ""
    puts "#{player.name} move:"
    print_cards(dealer, false)
    print_cards(player)
    print "What to do? (1 - hit, 2 - stand, 3 - open) : "    
    case get_player_answer('1', '2', '3')
      when '1' 
        @deal.take_card(player)
        print_cards(player)
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
    @game.players.each { |key, player| print_cards(player) }
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

  def get_player_answer(*param)
    input = ""    
    loop do 
      input = gets.chomp.to_s
      break if param.include? input
      puts "Incorrect answer."
      print "Try again: "
    end    
    input
  end

end
