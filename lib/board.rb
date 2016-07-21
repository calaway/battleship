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
    @board = Array.new(@size) { Array.new(@size, " ") }
  end

  def assign_square(coordinates, status)
    row, column = coordinates
    board[row][column] = status
  end

  def display_board
    display = ["===========\n. 1 2 3 4  ", "\nA ", " \nB ", " \nC ", " \nD ", " \n===========\n"]
    board.each_with_index do |row, row_index|
      row.each do |column|
        display[row_index + 1] << "#{column} "
      end
    end
    display.join
  end

    def hit?(coordinates)
      row, column = coordinates
      board[row][column] == "S"
    end

  def attack(coordinates)
    row, column = coordinates
    if board[row][column] == "S"
      assign_square(coordinates, "H")
    else
      assign_square(coordinates, "M")
    end
  end
end
