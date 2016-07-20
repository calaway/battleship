require './lib/player'
require './lib/board'
require './lib/messages'
require './lib/validate'

class Gamemaster
  attr_reader :player0,
              :player1,
              :difficulty

  def initialize(difficulty = "Beginner")
    @difficulty = "Beginner"
    @difficulty = difficulty if ["Intermediate","Advanced"].include?(difficulty)
    @player0 = Player.new(Board.new(@difficulty))
    @player1 = Player.new(Board.new(@difficulty))
  end

  def start
    welcome_sequence
    setup_sequence
  end

  def welcome_sequence
    messages = Messages.new
    puts "Welcome to BATTLESHIP"
    welcome_response = ""
    until welcome_response == "p"
      print messages.welcome(welcome_response)
      welcome_response = gets.chomp
    end
  end

  def setup_sequence
    messages = Messages.new
    validate = Validate.new
    print messages.setup_sequence
    player1.ships.each do |ship|
      valid_placement = false
      until valid_placement == true
        print messages.place_your_ship(ship)
        placement_response = gets.strip
        valid_placement = validate.valid_coordinate_pair?(placement_response) &&
                          validate.valid_placement?(player1, placement_response)
        messages.invalid_placement if valid_placement == false
      end
      placement_response = validate.format_placement(placement_response)
      player1.place_ship(placement_response)
    end
  end
end
