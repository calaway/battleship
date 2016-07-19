require 'minitest/autorun'
require './lib/player'
require './lib/board'

class PlayerTest < Minitest::Test
  def test_can_create_instance_of_player_with_a_board
    difficulty = "Beginner"
    player = Player.new(Board.new(difficulty))

    assert_instance_of Player, player
    assert_instance_of Board, player.board
  end

  def test_player_has_a_board_of_correct_size
    difficulty = "Beginner"
    player = Player.new(Board.new(difficulty))

    assert_equal 4, player.board.board.size
  end

  def test_player_can_place_ships
    player = Player.new(Board.new)
    player.place_ship([[0, 0], [0, 1]])
    player.place_ship([[1, 2], [2, 2], [3, 2]])

    assert_equal "S", player.board.board[0][0]
    assert_equal "S", player.board.board[0][1]
    assert_equal [["S", "S", nil, nil],
                  [nil, nil, "S", nil],
                  [nil, nil, "S", nil],
                  [nil, nil, "S", nil]], player.board.board
  end
end
