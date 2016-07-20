class Player
  attr_reader :board,
              :ships

  def initialize(board, ships = [2, 3])
    @board = board
    @ships = ships
  end

  def place_ship(coordinates)
    coordinates.each do |coordinate|
      board.assign_square(coordinate, "S")
    end
  end
end
