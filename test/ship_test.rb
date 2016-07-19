require 'minitest/autorun'
require './lib/ship'

class ShipTest < Minitest::Test
  def test_can_create_ship
    ship = Ship.new

    assert_instance_of Ship, ship
  end

  def test_can_get_ship_size
    ship = Ship.new

    assert_equal 2, ship.size
  end
end
