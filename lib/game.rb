require_relative 'board'
require_relative 'player'

class Game
  attr_reader :board

  def initialize(player = nil, size = [9,9])
    x, y = size
    @board = Board.new(x, y)
    @player = player.nil? ? HumanPlayer.new : player
  end

  def take_turn
    while true
      pos, action = @player.get_move(board.public_grid)

      case action
      when :flag
        return board.flag(pos)
      when :unflag
        return board.unflag(pos)
      when :reveal
        return board.reveal(pos)
      end

      puts "Sorry, try again."
    end
  end

  def play
    board.populate
    stepped_on_bomb = false
    until board.won? || stepped_on_bomb
      stepped_on_bomb = take_turn
    end
    board.reveal_bombs

    if stepped_on_bomb
      puts "Sorry, you lose!"
    else
      puts "You win!!"
    end
  end
end
