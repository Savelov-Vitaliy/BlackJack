module PointsCounter

  def get_points(cards)
    points = 0
    aces = cards.find_all { |card| card[0] == 'A' }
    cards -= aces    
    cards.each { |card| ['J', 'Q', 'K' ].include?(card[0]) ? points +=10 : points += card[0..-2].to_i }
    aces.each { |ace| points + 11 <= 21 ? points += 11 : points += 1 } unless aces.empty?
    points
  end

end
