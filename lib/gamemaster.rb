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
    main_gameplay_sequence
  end

  def welcome_sequence
    clear_screen
    puts "Welcome to BATTLESHIP"
    welcome_response = ""
    until welcome_response == "p" or welcome_response == "play"
      print Messages.welcome(welcome_response)
      abort if welcome_response == "q" or welcome_response == "quit"
      welcome_response = gets.strip.downcase
    end
  end

  def setup_sequence
    clear_screen
    print Messages.setup_sequence
    live_player_ship_placement_sequence
    clear_screen
    print Messages.setup_sequence_end
    puts player1.board.display_board
  end

  def live_player_ship_placement_sequence
    player1.ships.each do |ship|
      placement_valid = false
      until placement_valid == true
        print Messages.place_your_ship(ship)
        placement_response = gets.strip
        placement_valid = Validate.valid_coordinate_pair?(placement_response) &&
        Validate.valid_placement?(player1, ship, Validate.format_coordinate_pair(placement_response))
        print Messages.invalid_placement if placement_valid == false
      end
      placement_response = Validate.format_coordinate_pair(placement_response)
      placement_response = Validate.coordinate_fill
      player1.place_ship(placement_response)
    end
  end

  def main_gameplay_sequence

  end

  def clear_screen
    print "\e[2J\e[f"
  end
end
