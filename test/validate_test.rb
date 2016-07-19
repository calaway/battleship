require 'minitest/autorun'
require './lib/Validate'

class ValidateTest < Minitest::Test
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

    assert_equal 0, validate.distance([0, 0], [0, 1])
    assert_equal 0, validate.distance([2, 1], [0, 3])
    assert_equal 0, validate.distance([11, 1], [11, 11])
    assert_equal 0, validate.distance([10, 6], [6, 10])
  end
end
