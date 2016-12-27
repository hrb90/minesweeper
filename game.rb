require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board

  def initialize(player = nil)
    @board = Board.new
    @player = player.nil? ? HumanPlayer.new : player
  end

  def take_turn
    while true
      pos, action = @player.get_move(board.get_grid)

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
