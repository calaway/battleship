require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require './lib/board.rb'

class BoardTest < Minitest::Test
  def test_can_create_board
    difficulty = "Beginner"
    board = Board.new(difficulty)

    assert_instance_of Board, board
  end

  def test_beginner_board_has_4_rows_of_4_columns
    difficulty = "Beginner"
    board = Board.new(difficulty)

    assert_equal 4, board.board.length
    assert_equal [4, 4, 4, 4], [board.board[0].length,
                                board.board[1].length,
                                board.board[2].length,
                                board.board[3].length]
  end

  def test_intermediate_board_has_8_rows_of_8_columns
    difficulty = "Intermediate"
    board = Board.new(difficulty)

    assert_equal 8, board.board.length
    assert_equal [8, 8, 8, 8], [board.board[0].length,
                                board.board[1].length,
                                board.board[2].length,
                                board.board[3].length]

  end

  def test_advanced_board_has_12_rows_of_12_columns
    difficulty = "Advanced"
    board = Board.new(difficulty)

    assert_equal 12, board.board.length
    assert_equal [12, 12, 12, 12], [board.board[0].length,
                                    board.board[1].length,
                                    board.board[2].length,
                                    board.board[3].length]

  end

  def test_difficulty_defaults_to_beginner
    board = Board.new

    assert_equal 4, board.board.length
    assert_equal "Beginner", board.difficulty
  end

  def test_board_knows_its_difficulty_rating
    board = Board.new
    assert_equal "Beginner", board.difficulty

    board = Board.new("Beginner")
    assert_equal "Beginner", board.difficulty

    board = Board.new("Intermediate")
    assert_equal "Intermediate", board.difficulty

    board = Board.new("Advanced")
    assert_equal "Advanced", board.difficulty
  end

  def test_board_difficulty_is_beginner_for_any_invalid_argument_given
    board = Board.new("begin")
    assert_equal "Beginner", board.difficulty

    board = Board.new("middle")
    assert_equal "Beginner", board.difficulty

    board = Board.new(4)
    assert_equal "Beginner", board.difficulty

    board = Board.new(false)
    assert_equal "Beginner", board.difficulty
  end

  def test_board_knows_its_size
    board = Board.new
    assert_equal 4, board.size

    board = Board.new("Intermediate")
    assert_equal 8, board.size

    board = Board.new("Advanced")
    assert_equal 12, board.size

    board = Board.new(:ralph)
    assert_equal 4, board.size
  end

  def test_can_assign_individual_square_on_beginner_board
    board = Board.new
    board.assign_square([0, 0], "H")
    board.assign_square([1, 2], "M")
    board.assign_square([3, 1], "S")

    assert_equal "H", board.board[0][0]
    assert_equal "M", board.board[1][2]
    assert_equal nil, board.board[0][1]
    assert_equal [["H", nil, nil, nil],
                  [nil, nil, "M", nil],
                  [nil, nil, nil, nil],
                  [nil, "S", nil, nil]], board.board
  end

  def test_can_assign_individual_square_on_advanced_board
    board = Board.new("Advanced")
    board.assign_square([0, 0], "H")
    board.assign_square([11, 10], "M")
    board.assign_square([10, 11], "S")

    assert_equal "H", board.board[0][0]
    assert_equal "M", board.board[11][10]
    assert_equal "S", board.board[10][11]
    assert_equal nil, board.board[5][5]
  end

  def test_querying_square_returns_hit_or_miss_status
    skip
    board = Board.new("Advanced")
    board.assign_square("a1", "H")
    board.assign_square("l11", "M")
    board.assign_square("K12", "S")

    assert_equal nil, square_hit_or_miss_status("a1")
  end

  def test_can_return_visual_display_of_board
    skip
    board = Board.new

    assert_equal "===========
. 1 2 3 4
A
B
C
D
===========", board.display_board
  end
end
