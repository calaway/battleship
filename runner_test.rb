require "./lib/player"
require "./lib/Board"
require "./lib/validate"

player = Player.new(Board.new)
coordinates = player.random_ship_placement(3)
puts coordinates.inspect
player.place_ship(coordinates)
puts player.board.display_board

coordinates = coordinates.map { |coord| coord.reverse }
puts coordinates.inspect
player.place_ship(coordinates)
puts player.board.display_board
