require 'remedy'
require_relative 'player'

include Remedy

class CursorPlayer < Player
  attr_reader :cursor_pos, :input

  def initialize(name=nil)
    super
    @input = Interaction.new
    @cursor_pos = [0,0]
  end

  def  get_move(grid)
    render(grid)
    input.loop do |key|
      case key.to_s
      when 'up'
        move_cursor(grid, :up)
      when 'down'
        move_cursor(grid, :down)
      when 'left'
        move_cursor(grid, :left)
      when 'right'
        move_cursor(grid, :right)
      when 'f'
        return [cursor_pos, :flag]
      when 'u'
        return [cursor_pos, :unflag]
      when 'r'
        return [cursor_pos, :reveal]
      end
      render(grid)
    end
  end

  def move_cursor(grid, direction)
    dx, dy = DIRECTIONS[direction]
    x, y = cursor_pos
    new_x, new_y = x + dx, y + dy
    @cursor_pos = [new_x, new_y] if valid_pos?(grid, new_x, new_y)
  end

  def render(grid)
    grid_copy = grid.map(&:dup)
    unless cursor_pos.nil?
      x, y = cursor_pos
      grid_copy[x][y] = :c
    end
    super(grid_copy)
  end
end
