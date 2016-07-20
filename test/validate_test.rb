require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require './lib/validate'
require './lib/player'
require './lib/board'

class ValidateTest < Minitest::Test
  def test_assert_validity_of_given_coordinate
    validate = Validate.new

    assert validate.valid_coordinates?("A1")
    assert validate.valid_coordinates?("z12")
    assert validate.valid_coordinates?(" b1")
    refute validate.valid_coordinates?("1A")
    refute validate.valid_coordinates?("Z99 D3")
  end

  def test_asserts_validity_of_given_coordinate_pair
    validate = Validate.new

    refute validate.valid_coordinate_pair?("A0 j111")
    refute validate.valid_coordinate_pair?("A0 AA")
    assert validate.valid_coordinate_pair?(" A0  A1 ")
    assert validate.valid_coordinate_pair?("L11 d5")
    refute validate.valid_coordinate_pair?("B2")
  end

  def test_can_translate_row_column_notation
    validate = Validate.new

    assert_equal [0, 0], validate.coordinate_translation("A1")
    assert_equal [1, 3], validate.coordinate_translation("b4")
    assert_equal [11, 10], validate.coordinate_translation("l11")
    assert_equal [10, 11], validate.coordinate_translation("k12")
  end

  def test_can_tell_if_coordinates_are_same_column_or_row
    validate = Validate.new

    assert validate.same_row_or_column?([0, 0], [0, 1])
    refute validate.same_row_or_column?([2, 1], [0, 3])
    assert validate.same_row_or_column?([11, 1], [11, 11])
    refute validate.same_row_or_column?([10, 6], [6, 10])
  end

  def test_can_return_distance_between_two_coordinates
    validate = Validate.new

    assert_equal 1, validate.distance([0, 0], [0, 1])
    assert_equal 4, validate.distance([2, 1], [0, 3])
    assert_equal 10, validate.distance([11, 1], [11, 11])
    assert_equal 8, validate.distance([10, 6], [6, 10])
  end

  def test_can_fill_in_intermediate_coordinates
    validate = Validate.new
    result = [[0, 0], [0, 1], [0, 2], [0, 3]]
    assert_equal result, validate.coordinate_fill([0, 0], [0, 3])

    result = [[11, 9], [11, 10], [11, 11]]
    assert_equal result, validate.coordinate_fill([11, 9], [11, 11])

    result = [[3, 5], [4, 5], [5, 5], [6, 5]]
    assert_equal result, validate.coordinate_fill([6, 5], [3, 5])

    result = [[3, 8], [3, 9], [3, 10], [3, 11]]
    assert_equal result, validate.coordinate_fill([3, 11], [3, 8])
  end

  def test_validate_ship_is_in_bounds
    validate = Validate.new

    refute validate.inbounds?([0, 12])
    assert validate.inbounds?([3, 1])
    assert validate.inbounds?([11, 11], "Advanced")
    refute validate.inbounds?([8, 3], "Intermediate")
  end

  def test_returns_coordinate_pair_from_user_input
    validate = Validate.new

    assert_equal [[0, 0], [0, 1]], validate.format_coordinate_pair(" A1  A2 ")
    assert_equal [[11, 10], [1, 1]], validate.format_coordinate_pair(" l11  b2 ")
  end

  def test_tells_if_ships_overlap
    validate = Validate.new
    player = Player.new(Board.new("Advanced"))
    player.board.assign_square([0, 2], "S")
    player.board.assign_square([8, 8], "S")

    assert validate.ships_not_overlap?(player, [0, 0], [0, 1])
    refute validate.ships_not_overlap?(player, [0, 0], [0, 3])
    assert validate.ships_not_overlap?(player, [7, 7], [9, 7])
    refute validate.ships_not_overlap?(player, [8, 8], [8,10])
  end

  def test_asserts_validity_of_placement_is_not_diagonal
    validate = Validate.new
    player = Player.new(Board.new("Advanced"))

    assert validate.valid_placement?(player, 3, [[0, 0], [0, 2]])
    refute validate.valid_placement?(player, 3, [[0, 0], [1, 1]])
    assert validate.valid_placement?(player, 4, [[11, 11], [8, 11]])
    refute validate.valid_placement?(player, 4, [[11, 11], [9, 10]])
  end

  def test_asserts_validity_of_placement_is_correct_distance_for_ship
    validate = Validate.new
    player = Player.new(Board.new("Advanced"))

    assert validate.valid_placement?(player, 3, [[0, 0], [0, 2]])
    refute validate.valid_placement?(player, 2, [[0, 0], [0, 2]])
    assert validate.valid_placement?(player, 4, [[11, 9], [11, 6]])
    refute validate.valid_placement?(player, 3, [[11, 9], [11, 6]])
  end

  def test_asserts_validity_of_placement_is_in_bounds
    validate = Validate.new
    player = Player.new(Board.new("Advanced"))

    assert validate.valid_placement?(player, 3, [[10, 0], [10, 2]])
    refute validate.valid_placement?(player, 3, [[0, 10], [0, 12]])
    assert validate.valid_placement?(player, 4, [[11, 9], [11, 6]])
    refute validate.valid_placement?(player, 4, [[11, 9], [11, 12]])
  end

  def test_asserts_validity_of_placement_is_not_overlapping
    validate = Validate.new
    player = Player.new(Board.new("Advanced"))
    player.board.assign_square([0, 2], "S")
    player.board.assign_square([8, 8], "S")


    assert validate.valid_placement?(player, 3, [[0, 1], [2, 1]])
    refute validate.valid_placement?(player, 3, [[0, 1], [0, 3]])
    assert validate.valid_placement?(player, 4, [[8, 7], [8, 4]])
    refute validate.valid_placement?(player, 4, [[6, 8], [9, 8]])
  end
end
