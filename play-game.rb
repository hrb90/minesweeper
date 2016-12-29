require_relative 'game'
require_relative 'player'

cp = ComputerPlayer.new
Game.new(cp, [30, 16]).play
