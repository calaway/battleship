module Validate
  def self.valid_coordinates?(user_input)
    return false unless user_input.class == String
    user_input = user_input.upcase.strip
    ('A'..'Z').include?(user_input[0]) &&
    ('0'..'99').to_a.include?(user_input[1..-1])
  end

  def self.valid_coordinate_pair?(user_input)
    split = user_input.split(' ').map { |coord| coord.strip }
    if split.length != 2
      false
    elsif !valid_coordinates?(split[0]) || !valid_coordinates?(split[1])
      false
    else
      true
    end
  end

  def self.coordinate_translation(human_notation)
    human_notation = human_notation.upcase.strip
    matrix_notation = []
    matrix_notation[0] = human_notation[0].ord - "A".ord
    matrix_notation[1] = human_notation[1..-1].to_i - 1
    matrix_notation
  end

  def self.format_coordinate_pair(user_input)
    human_notation = user_input.split(' ').map { |coord| coord.strip }
    matrix_notation = human_notation.map do |coord|
      coordinate_translation(coord)
    end
  end

  def self.same_row_or_column?(coordinate0, coordinate1)
    coordinate0[0] == coordinate1[0] || coordinate0[1] == coordinate1[1]
  end

  def self.distance(coordinate0, coordinate1)
    (coordinate0[0] - coordinate1[0]).abs +
    (coordinate0[1] - coordinate1[1]).abs
  end

  def self.coordinate_fill(coordinate0, coordinate1)
    if coordinate0[0] == coordinate1[0]
      axis = 1
    else
      axis = 0
    end
    first, last = [coordinate0[axis], coordinate1[axis]].sort
    (first..last).map do |index|
      coord = Array.new(2)
      coord[(axis + 1) % 2] = coordinate0[(axis + 1) % 2]
      coord[axis] = index
      coord
    end
  end

  def self.inbounds?(coordinates, difficulty = "Beginner")
    if difficulty == "Advanced"
      size = (0..11).to_a
    elsif difficulty == "Intermediate"
      size = (0..7).to_a
    else
      size = (0..3).to_a
    end
    size.include?(coordinates[0]) && size.include?(coordinates[1])
  end

  def self.ships_not_overlap?(player, coordinate0, coordinate1)
    coordinate_fill = coordinate_fill(coordinate0, coordinate1)
    coordinate_fill.all? do |coord|
      player.board.board[coord[0]][coord[1]] != "S"
    end
  end

  def self.valid_placement?(player, ship, coordinates)
    coordinate0, coordinate1 = coordinates
    same_row_or_column?(coordinate0, coordinate1) &&
    distance(coordinate0, coordinate1) + 1 == ship &&
    inbounds?(coordinate0, player.board.difficulty) &&
    inbounds?(coordinate1, player.board.difficulty) &&
    ships_not_overlap?(player, coordinate0, coordinate1)
  end

  def self.random_coordinate_generator(ship, board_size)
    row = rand(board_size)
    column = rand(board_size - (ship - 1))
    coordinates = [[row, column], [row, (column + ship - 1)]]
    if rand(2) == 1
      coordinates = coordinates.map { |coord| coord.reverse }
    end
    coordinates
  end

  def self.valid_attack?(matrix_notation, board)
    row, column = matrix_notation
    inbounds?(matrix_notation) &&
    !["H", "M"].include?(board.board[row][column])
  end

  def self.random_attack_generator(board_size)
    [rand(board_size), rand(board_size)]
  end
end
