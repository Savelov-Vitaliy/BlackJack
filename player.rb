class Player
  attr_reader :name
  attr_accessor :account, :cards, :stands

  def initialize(name)
    @name = name
    @account = 0
    @cards = []
    @stands = 0
  end
end
