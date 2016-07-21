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
    print Messages.clear_screen
    puts "Welcome to BATTLESHIP"
    welcome_response = ""
    until welcome_response == "p" or welcome_response == "play"
      print Messages.welcome(welcome_response)
      abort if welcome_response == "q" or welcome_response == "quit"
      welcome_response = gets.strip.downcase
    end
  end

  def setup_sequence
    cpu_ship_placement
    print Messages.clear_screen
    print Messages.setup_sequence
    live_player_ship_placement_sequence
    print Messages.clear_screen
    print Messages.setup_sequence_end
  end

  def live_player_ship_placement_sequence
    player1.ships.each do |ship|
      placement_valid = false
      until placement_valid
        print Messages.place_your_ship(ship)
        placement_response = gets.strip
        placement_valid = Validate.valid_coordinate_pair?(placement_response) &&
        Validate.valid_placement?(player1, ship, Validate.format_coordinate_pair(placement_response))
        print Messages.invalid_placement if placement_valid == false
      end
      placement_response = Validate.format_coordinate_pair(placement_response)
      player1.place_ship(placement_response)
    end
  end

  def cpu_ship_placement
    player0.ships.each do |ship|
      placement_valid = false
      until placement_valid
        coordinates = Validate.random_coordinate_generator(ship, player0.board.size)
        placement_valid = Validate.valid_placement?(player0, ship, coordinates)
      end
      player0.place_ship(coordinates)
    end
  end

  def main_gameplay_sequence
    while true
      live_player_shot_sequence
      cpu_shot_sequence
    end
  end

  def live_player_shot_sequence
    print Messages.clear_screen
    display_both_boards
    print "Enter attack coordinate:\n> "
    attack_coordinates = gets.strip
    if !Validate.valid_coordinates?(attack_coordinates)
      valid = false
    elsif Validate.valid_attack?(Validate.coordinate_translation(attack_coordinates), player0.board)
      valid = true
    else
      valid = false
    end
    until valid
      print Messages.invalid_attack
      attack_coordinates = gets.strip
      if !Validate.valid_coordinates?(attack_coordinates)
        valid = false
      elsif Validate.valid_attack?(Validate.coordinate_translation(attack_coordinates, player0.board))
        valid = true
      else
        valid = false
      end
    end
    attack_coordinates = Validate.coordinate_translation(attack_coordinates)
    print Messages.hit_or_miss(player0.board.hit?(attack_coordinates))
    player0.board.attack(attack_coordinates)
    unless player0.board.board.flatten.include?("S")
      abort("YOU WIN !!!")
    end
    display_both_boards
    print Messages.end_turn
    gets
  end

  def cpu_shot_sequence
    valid = false
    until valid
      attack_coordinates = Validate.random_attack_generator(player1.board.size)
      valid = Validate.valid_attack?(attack_coordinates, player1.board)
    end
    player1.board.attack(attack_coordinates)
    print Messages.cpu_attacked(attack_coordinates)
    display_both_boards
    unless player1.board.board.flatten.include?("S")
      abort("You lose.\n\nGAME OVER")
    end
    print Messages.clear_screen
    print Messages.end_turn
    gets
  end

  def display_both_boards
    print "YOUR BOARD:\n#{player1.board.display_board}"
    print "OPPONENT'S BOARD:\n#{player0.board.display_board.gsub("S", " ")}"
  end
end
