require_relative 'game'
require_relative 'player'

cp = ComputerPlayer.new
Game.new(cp, [16, 16]).play
