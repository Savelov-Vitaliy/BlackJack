class Player

  attr_reader :name
  attr_accessor :account, :cards

  def initialize(name)
    @name = name
    @account = 0
    @cards = []
  end

end
