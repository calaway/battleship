require 'minitest/autorun'
require './lib/user_input'

class UserInputTest < Minitest::Test
  def test_can_ask_opening_question
    assert ["p", "i", "q"].include?(UserInput.new.welcome)
  end

  def test_can_ask_for_ship_placement_coordinates
    
  end
end
