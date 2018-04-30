class Player

  attr_accessor :name, :account, :cards

  def initialize(name)
    @name = name
    @account = 0
    @cards = []
  end

end
