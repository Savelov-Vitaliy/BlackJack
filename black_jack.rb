class BlackJack

  attr_reader :players

  def initialize(player_name)
    @players = {}
    @players[:player] = Player.new(player_name)
    @players[:dealer] = Player.new('Dealer')    
  end

  def start_new_game
    @players.each { |key, player| player.account = 100 }
  end

  def game_over?    
    game_over = false
    @players.each { |key, player| game_over |= player.account <= 0 }    
    game_over
  end

  def new_deal
    Deal.new(@players)
  end


end
