class Player
  attr_reader :name
  attr_accessor :account, :cards, :points, :stands

  def initialize(name)
    @name = name
    @account = 0
    @cards = []
    @points = 0
    @stands = 0
  end
end
