class Deal
  attr_reader :bet, :bank, :winner

  def initialize(game)
    @game = game
    @deck = Deck.new
    @game.players.each do |_key, player|
      player.stands = 0
      player.cards = []
      2.times { take_card(player) }
    end
    @bank = 0
    @bet = 10
    bets
  end

  def can_player_hit?
    @game.players[:player].cards.size < 3
  end

  def move(player_answer)
    return end_deal if player_move(player_answer)
    dealer_move
    return end_deal if cards_oveflow? || stends_oveflow?
    false
  end

  private

  def player_move(player_answer)
    player = @game.players[:player]
    case player_answer
    when '1'
      take_card(player)
    when '2'
      player.stands += 1
    when '3'
      return true
    end
    false
  end

  def dealer_move
    dealer = @game.players[:dealer]
    take_card(dealer) if count_points(dealer.cards) < 17
    dealer.cards.size == 2 ? dealer.stands += 1 : dealer.stands = 0
  end

  def bets
    @game.players.each do |_key, player|
      player.account -= @bet
      @bank += @bet
    end
  end

  def stends_oveflow?
    (@game.players[:player].stands + @game.players[:dealer].stands) > 2
  end

  def cards_oveflow?
    @game.players[:player].cards.size >= 3 && @game.players[:dealer].cards.size >= 3
  end

  def end_deal
    @winner = aword_victory
    if @winner.to_s.empty?
      @game.players.each { |_key, player| player.account += @bet }
      @winner = nil
    else
      @winner.account += @bank
    end
    true
  end

  def aword_victory
    player = @game.players[:player]
    dealer = @game.players[:dealer]
    player_points = count_points(@game.players[:player].cards)
    dealer_points = count_points(@game.players[:dealer].cards)
    return nil if (player_points > 21 && dealer_points > 21) || player_points == dealer_points
    return player if dealer_points > 21
    return dealer if player_points > 21
    player_points > dealer_points || player_points > 21 ? player : dealer
  end

  def take_card(player)
    if player.cards.size < 3
      player.cards << @deck.sample_card
      player.points = count_points(player.cards)
    end
    true
  end

  def count_points(cards)
    points = 0
    aces = cards.find_all { |card| card[0] == 'A' }
    cards -= aces
    cards.each { |card| points += %w[J Q K].include?(card[0]) ? 10 : card[0..-2].to_i }
    aces.each { |_ace| points += points + 11 <= 21 ? 11 : 1 } unless aces.empty?
    points
  end
end
