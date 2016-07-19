require './lib/player'
require './lib/board'

class Gamemaster
  attr_reader :player0,
              :player1,
              :difficulty

  def initialize(difficulty = "Beginner")
    @difficulty = "Beginner"
    @difficulty = difficulty if ["Intermediate","Advanced"].include?(difficulty)
    @player0 = Player.new(Board.new(@difficulty))
    @player1 = Player.new(Board.new(@difficulty))
  end
end
