require_relative 'board'

class Game

  ACTIONS = {
  "flag" => :flag,
  "f" => :flag,
  "reveal" => :reveal,
  "r" => :reveal,
  "unflag" => :unflag,
  "u" => :unflag

  }
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def take_turn
    while true
      pos = get_pos
      action = get_action

      if action == :flag
        return board.flag(pos)
      elsif action == :unflag
        return board.unflag(pos)
      elsif action == :reveal
        return board.reveal(pos)
      end

      puts "Sorry, try again."
    end
  end

  def get_pos
    puts "Enter a position."
    gets.chomp.split(",").map(&:to_i)
  end

  def get_action
    puts "Enter 'reveal', 'flag', or 'unflag'."
    ACTIONS[gets.chomp]
  end

  def play
    board.populate
    stepped_on_bomb = false
    until board.won? || stepped_on_bomb
      board.render
      stepped_on_bomb = take_turn
    end
    board.reveal_bombs
    board.render
    if stepped_on_bomb
      puts "Sorry, you lose!"
    else
      puts "You win!!"
    end
  end
end
