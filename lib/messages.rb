module Messages
  def self.welcome(user_input)
    if user_input == "i" || user_input == "instructions"
      "\n\n#{' Instructions '.center(80, '=')}\n\nPrepare For Battle!\nThe computer will place ships and then you will be prompted to place ships. Select the start and end coordinates you wish the ship to occupy.\n\nRules for placing ships:\n* Place each ship in any horizontal or vertical position, but not diagonally.\n* Do not place a ship that any part of it overlaps letters, numbers, the edge of the grid, or another ship.\n\nHow to Play:\nOn your turn pick a target space to attack and enter its location by letter and number. If you pick a space occupied by a ship on your opponent's ocean grid, your shot is a hit! If you pick a space that is not occupied by a ship on your opponent's ocean grid, it is a miss. After a hit or miss, your turn is over. Play continues in this manner, with you and your opponent picking spaces one shot per turn.\n\nSinking a Ship:\nOnce all the spaces any one ship occupies have been attacked, it has been sunk.\n\nWinning the Game:\nIf you are the first player to sink all of your opponents ships, you win the game!\n\nWould you like to (p)lay, read the (i)nstructions, or (q)uit?\n> "
    elsif user_input == "q" || user_input == "quit"
      "Game Over\n\n"
    else
      "Would you like to (p)lay, read the (i)nstructions, or (q)uit?\n> "
    end
  end

  def self.setup_sequence
    "I have laid out my ships on the grid.\nYou now need to layout your two ships.\nThe first is two units long and the\nsecond is three units long.\nThe grid has A1 at the top left and D4 at the bottom right.\n\n"
  end

  def self.place_your_ship(ship)
    "Enter the beginning and ending squares for the #{ship} unit ship:\n> "
  end

  def self.invalid_placement
    "Unfortunately your ship placement is not valid. Please review the following requirements and try again:\n* Enter only the coordinates corresponding to the two ends of your ship.\n* The format of entries must match this example: 'B2 B4'.\n* Entries must be on the same row or column (no diagonal ship placements).\n* Coordinates cannot be outside of the board boundaries.\n* Ships cannot overlap.\n\n"
  end

  def self.setup_sequence_end
    "You have placed your ships. Prepare for battle!\n\n"
  end

  def self.clear_screen
    "\e[2J\e[f"
  end
end
