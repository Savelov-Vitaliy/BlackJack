class GameInterface
  PLAYER_OPTIONS = { '1' => '1 - hit, ', '2' => '2 - stand, ', '3' => '3 - open' }.freeze
  EXIT_OPTIONS = { 'y' => 'y/', 'n' => 'n' }.freeze

  def initialize
    puts 'Welcome to BlackJack game. Let`s start!'
    print 'Input your name: '
    @game = BlackJack.new(gets.chomp.capitalize)
    new_game
  end

  def new_game
    @game.new_game
    print_new_game
    new_deal
  end

  def new_deal
    @game.new_deal
    print_new_deal
    move
  end

  def move
    loop do
      print_player_move
      break if @game.deal.move(player_answer)
      print_dealer_move
    end
    open_cards
  end

  def open_cards
    print_open_cards
    if play_again?
      @game.game_over? ? new_game : new_deal
    else
      puts "\nGoodbye"
    end
  end

  def player_answer
    print 'What to do? ('
    options = PLAYER_OPTIONS.dup
    options.delete('1') unless @game.deal.can_player_hit?
    options.each { |_answer, hint| print hint }
    print ') : '
    answer_filtr(options.keys)
  end

  def print_player_move
    puts "\n#{@game.players[:player].name} move:"
    print_cards(false)
  end

  def print_dealer_move
    puts "\n#{@game.players[:dealer].name} move:"
    print_card(@game.players[:dealer], false)
  end

  def print_new_game
    puts "\nNew game"
    print_accounts
  end

  def print_new_deal
    puts "\nNew deal\nBet: $#{@game.deal.bet}. Bank: $#{@game.deal.bank}"
    print_accounts
  end

  def play_again?
    print "\nPlay again? ("
    EXIT_OPTIONS.each { |_answer, hint| print hint }
    print ') : '
    answer_filtr(EXIT_OPTIONS.keys) == 'y'
  end

  def print_open_cards
    puts "\nOpen cards:"
    print_cards
    winner = @game.deal.winner
    winner = 'draw' if winner.to_s.empty?
    puts "\nWinner: #{winner}"
    print_accounts
  end

  def print_accounts
    @game.players.each { |_key, player| print "#{player.name}: $#{player.account}. " }
    puts ''
  end

  def print_cards(open = true)
    print_card(@game.players[:dealer], open)
    print_card(@game.players[:player])
  end

  def print_card(player, open = true)
    print "#{player.name} cards: "
    print open ? "#{player.cards.join ' '}, " : "#{player.cards.size} cards. "
    puts open ? " points: #{@game.deal.get_points(player.cards)}" : ''
  end

  def answer_filtr(*param)
    input = ''
    loop do
      input = gets.chomp.to_s
      break if param[0].include? input
      print 'Incorrect answer. Try again: '
    end
    input
  end
end
