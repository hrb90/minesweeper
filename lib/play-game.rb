require_relative 'game'
require_relative 'cursor_player'

cp = CursorPlayer.new
Game.new(cp, [16, 16]).play
