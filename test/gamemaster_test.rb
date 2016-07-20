require 'minitest/autorun'
require './lib/gamemaster'

class GamemasterTest < Minitest::Test
  def test_can_initialize_game
    gamemaster = Gamemaster.new

    assert_instance_of Gamemaster, gamemaster
  end

  def test_gamemaster_initializes_2_players_with_1_board_each
    gamemaster = Gamemaster.new

    assert_instance_of Player, gamemaster.player0
    assert_equal 4, gamemaster.player1.board.size
    assert_equal 4, gamemaster.player0.board.board.length
  end

  def test_game_knows_its_difficulty_rating
    gamemaster = Gamemaster.new("Beginner")
    assert_equal "Beginner", gamemaster.difficulty

    gamemaster = Gamemaster.new("Intermediate")
    assert_equal "Intermediate", gamemaster.difficulty

    gamemaster = Gamemaster.new("Advanced")
    assert_equal "Advanced", gamemaster.difficulty
  end

  def test_difficulty_defaults_to_beginner
    gamemaster = Gamemaster.new

    assert_equal "Beginner", gamemaster.difficulty
  end

  def test_difficulty_defaults_to_beginner_for_any_invalid_argument_given
    gamemaster = Gamemaster.new("easy")
    assert_equal "Beginner", gamemaster.difficulty

    gamemaster = Gamemaster.new(:badger)
    assert_equal "Beginner", gamemaster.difficulty

    gamemaster = Gamemaster.new(4)
    assert_equal "Beginner", gamemaster.difficulty

    gamemaster = Gamemaster.new(false)
    assert_equal "Beginner", gamemaster.difficulty
  end

  def test_player_can_place_ships
    gamemaster = Gamemaster.new
    gamemaster.player0.place_ship([[0, 0], [0, 1]])
    gamemaster.player0.place_ship([[1, 2], [2, 2], [3, 2]])

    assert_equal "S", gamemaster.player0.board.board[0][0]
    assert_equal "S", gamemaster.player0.board.board[0][1]
    assert_equal [["S", "S", nil, nil],
                  [nil, nil, "S", nil],
                  [nil, nil, "S", nil],
                  [nil, nil, "S", nil]], gamemaster.player0.board.board
  end
end
