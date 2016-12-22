require_relative 'board'

class Game

  ACTIONS = {
  "flag" => :flag,
  "f" => :flag,
  "reveal" => :reveal,
  "r" => :reveal

  }
  attr_reader :board

  def initialize
    @board = Board.new
  end

  def take_turn
    pos = get_pos
    action = get_action

    if action == :flag
      board.flag(pos)
    else
      board.reveal(pos)
    end
  end

  def get_pos
    puts "Enter a position."
    gets.chomp.split(",").map(&:to_i)
  end

  def get_action
    puts "Enter 'flag' or 'reveal'."
    ACTIONS[gets.chomp]
  end

  def play
    board.populate
    stepped_on_bomb = false
    until board.won? || stepped_on_bomb
      board.render
      stepped_on_bomb = take_turn
    end
    board.render
    if stepped_on_bomb
      puts "Sorry, you lose!"
    else
      puts "You win!!"
    end
  end
end
