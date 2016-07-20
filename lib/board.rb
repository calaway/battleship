class Board
  attr_reader :board,
              :difficulty,
              :size

  def initialize(difficulty = "Beginner")
    @difficulty = "Beginner"
    @difficulty = difficulty if ["Intermediate","Advanced"].include?(difficulty)
    board_sizes = {"Beginner"     => 4,
                   "Intermediate" => 8,
                   "Advanced"     => 12}
    @size = board_sizes[@difficulty]
    @board = Array.new(@size) { Array.new(@size) }
  end

  def assign_square(coordinates, status)
    row, column = coordinates
    board[row][column] = status
  end
end
