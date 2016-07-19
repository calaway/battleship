class Player
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def place_ship(coordinates)
    coordinates.each do |coordinate|
      board.assign_square(coordinate, "S")
    end
  end
end
