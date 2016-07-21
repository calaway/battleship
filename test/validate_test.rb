require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require './lib/validate'
require './lib/player'
require './lib/board'

class ValidateTest < Minitest::Test
  def test_assert_validity_of_given_coordinate

    assert Validate.valid_coordinates?("A1")
    assert Validate.valid_coordinates?("z12")
    assert Validate.valid_coordinates?(" b1")
    refute Validate.valid_coordinates?("1A")
    refute Validate.valid_coordinates?("Z99 D3")
  end

  def test_asserts_validity_of_given_coordinate_pair

    refute Validate.valid_coordinate_pair?("A0 j111")
    refute Validate.valid_coordinate_pair?("A0 AA")
    assert Validate.valid_coordinate_pair?(" A0  A1 ")
    assert Validate.valid_coordinate_pair?("L11 d5")
    refute Validate.valid_coordinate_pair?("B2")
  end

  def test_can_translate_row_column_notation

    assert_equal [0, 0], Validate.coordinate_translation("A1")
    assert_equal [1, 3], Validate.coordinate_translation("b4")
    assert_equal [11, 10], Validate.coordinate_translation("l11")
    assert_equal [10, 11], Validate.coordinate_translation("k12")
  end

  def test_can_tell_if_coordinates_are_same_column_or_row

    assert Validate.same_row_or_column?([0, 0], [0, 1])
    refute Validate.same_row_or_column?([2, 1], [0, 3])
    assert Validate.same_row_or_column?([11, 1], [11, 11])
    refute Validate.same_row_or_column?([10, 6], [6, 10])
  end

  def test_can_return_distance_between_two_coordinates
    assert_equal 1, Validate.distance([0, 0], [0, 1])
    assert_equal 4, Validate.distance([2, 1], [0, 3])
    assert_equal 10, Validate.distance([11, 1], [11, 11])
    assert_equal 8, Validate.distance([10, 6], [6, 10])
  end

  def test_can_fill_in_intermediate_coordinates
    result = [[0, 0], [0, 1], [0, 2], [0, 3]]
    assert_equal result, Validate.coordinate_fill([0, 0], [0, 3])

    result = [[11, 9], [11, 10], [11, 11]]
    assert_equal result, Validate.coordinate_fill([11, 9], [11, 11])

    result = [[3, 5], [4, 5], [5, 5], [6, 5]]
    assert_equal result, Validate.coordinate_fill([6, 5], [3, 5])

    result = [[3, 8], [3, 9], [3, 10], [3, 11]]
    assert_equal result, Validate.coordinate_fill([3, 11], [3, 8])

    result = [[3, 0], [3, 1]]
    assert_equal result, Validate.coordinate_fill([3, 0], [3, 1])
  end

  def test_validate_ship_is_in_bounds
    refute Validate.inbounds?([0, 12])
    assert Validate.inbounds?([3, 1])
    assert Validate.inbounds?([11, 11], "Advanced")
    refute Validate.inbounds?([8, 3], "Intermediate")
  end

  def test_returns_coordinate_pair_from_user_input

    assert_equal [[0, 0], [0, 1]], Validate.format_coordinate_pair(" A1  A2 ")
    assert_equal [[11, 10], [1, 1]], Validate.format_coordinate_pair(" l11  b2 ")
  end

  def test_tells_if_ships_overlap
    player = Player.new(Board.new("Advanced"))
    player.board.assign_square([0, 2], "S")
    player.board.assign_square([8, 8], "S")

    assert Validate.ships_not_overlap?(player, [0, 0], [0, 1])
    refute Validate.ships_not_overlap?(player, [0, 0], [0, 3])
    assert Validate.ships_not_overlap?(player, [7, 7], [9, 7])
    refute Validate.ships_not_overlap?(player, [8, 8], [8,10])
  end

  def test_asserts_validity_of_placement_is_not_diagonal
    player = Player.new(Board.new("Advanced"))

    assert Validate.valid_placement?(player, 3, [[0, 0], [0, 2]])
    refute Validate.valid_placement?(player, 3, [[0, 0], [1, 1]])
    assert Validate.valid_placement?(player, 4, [[11, 11], [8, 11]])
    refute Validate.valid_placement?(player, 4, [[11, 11], [9, 10]])
  end

  def test_asserts_validity_of_placement_is_correct_distance_for_ship
    player = Player.new(Board.new("Advanced"))

    assert Validate.valid_placement?(player, 3, [[0, 0], [0, 2]])
    refute Validate.valid_placement?(player, 2, [[0, 0], [0, 2]])
    assert Validate.valid_placement?(player, 4, [[11, 9], [11, 6]])
    refute Validate.valid_placement?(player, 3, [[11, 9], [11, 6]])
  end

  def test_asserts_validity_of_placement_is_in_bounds
    player = Player.new(Board.new("Advanced"))

    assert Validate.valid_placement?(player, 3, [[10, 0], [10, 2]])
    refute Validate.valid_placement?(player, 3, [[0, 10], [0, 12]])
    assert Validate.valid_placement?(player, 4, [[11, 9], [11, 6]])
    refute Validate.valid_placement?(player, 4, [[11, 9], [11, 12]])
  end

  def test_asserts_validity_of_placement_is_not_overlapping
    player = Player.new(Board.new("Advanced"))
    player.board.assign_square([0, 2], "S")
    player.board.assign_square([8, 8], "S")

    assert Validate.valid_placement?(player, 3, [[0, 1], [2, 1]])
    refute Validate.valid_placement?(player, 3, [[0, 1], [0, 3]])
    assert Validate.valid_placement?(player, 4, [[8, 7], [8, 4]])
    refute Validate.valid_placement?(player, 4, [[6, 8], [9, 8]])
  end

  def test_can_generate_valid_random_coordinages
    player = Player.new(Board.new)
    coordinates = Validate.random_coordinate_generator(2, 4)
    assert Validate.valid_placement?(player, 2, coordinates)

    coordinates = Validate.random_coordinate_generator(3, 4)
    assert Validate.valid_placement?(player, 3, coordinates)

    coordinates = Validate.random_coordinate_generator(4, 4)
    assert Validate.valid_placement?(player, 4, coordinates)
  end

  def test_asserts_validity_of_attack
    player = Player.new(Board.new)
    player.board.assign_square([0, 2], "H")
    player.board.assign_square([3, 3], "M")
    player.board.assign_square([2, 3], "S")

    refute Validate.valid_attack?([0, 2], player.board)
    refute Validate.valid_attack?([3, 3], player.board)
    assert Validate.valid_attack?([2, 3], player.board)
    assert Validate.valid_attack?([3, 2], player.board)
    refute Validate.valid_attack?([4, 0], player.board)
  end

  def test_valid_human_attack
    player = Player.new(Board.new)

    refute Validate.valid_human_attack?('e1', player.board)
  end
end
