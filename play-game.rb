require_relative 'game'
require_relative 'player'

cp = CursorPlayer.new
Game.new(cp, [16, 16]).play
