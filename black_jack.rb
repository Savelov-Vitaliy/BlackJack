class BlackJack
  attr_reader :players, :deal

  def initialize(player_name)
    @players = {}
    @players[:player] = Player.new(player_name)
    @players[:dealer] = Player.new('Dealer')
  end

  def new_game
    @players.each { |_key, player| player.account = 100 }
  end

  def new_deal
    @deal = Deal.new(self)
  end

  def game_over?
    @players[:player].account <= 0 || @players[:dealer].account <= 0
  end
end
