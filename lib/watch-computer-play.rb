require_relative 'game'
require_relative 'computer_player'

cp = ComputerPlayer.new
Game.new(cp, [16, 16]).play
