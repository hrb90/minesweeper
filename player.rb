require 'remedy'
require_relative 'tile'

include Remedy

class Player
  ACTIONS = {
  "flag" => :flag,
  "f" => :flag,
  "reveal" => :reveal,
  "r" => :reveal,
  "unflag" => :unflag,
  "u" => :unflag
  }

  DIRECTIONS = {
    :up => [-1, 0],
    :down => [1, 0],
    :left => [0, -1],
    :right => [0, 1]
  }

  def initialize(name=nil)
    @name = name.nil? ? "Outis" : name
  end

  def get_move(board)

  end

  def valid_pos?(grid, x, y)
    (0...grid.length).include?(x) && (0...grid[0].length).include?(y)
  end
end

class HumanPlayer < Player
  def get_move(grid)
    render(grid)
    pos = get_pos
    action = get_action
    [pos, action]
  end

  def get_pos
    puts "Enter a position."
    gets.chomp.split(",").map(&:to_i)
  end

  def get_action
    puts "Enter 'reveal', 'flag', or 'unflag'."
    ACTIONS[gets.chomp]
  end
end

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
    system "clear"
    grid_copy = grid.map(&:dup)
    unless cursor_pos.nil?
      x, y = cursor_pos
      grid_copy[x][y] = :c
    end
    grid_copy.each do |row|
      puts row.map { |x| Tile.sym_to_txt(x) }.join
    end
  end
end

class ComputerPlayer < Player
  DELTAS = [[-1, -1],
            [-1, 0],
            [-1, 1],
            [0, -1],
            [0, 1],
            [1, -1],
            [1, 0],
            [1, 1]
          ]

  def initialize(name=nil)
    super
    @move_stack = []
  end

  def get_move(grid)
    sleep(0.5)
    return @move_stack.pop unless @move_stack.empty?
    generate_moves(grid)
    @move_stack.pop
  end

  def get_neighbors(grid, x, y)
    neighbors_with_pos = []
    DELTAS.each do |delta_x, delta_y|
      new_x, new_y = x + delta_x, y + delta_y
      if valid_pos?(grid, new_x, new_y)
        neighbors_with_pos << [grid[new_x][new_y], [new_x, new_y]]
      end
    end
    neighbors_with_pos
  end

  def add_to_stack(pos, action)
    @move_stack << [pos, action] unless @move_stack.include?([pos, action])
  end

  def generate_moves(grid)
    unrevealed = []
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        neighbors = get_neighbors(grid, i, j)
        if tile.is_a?(Fixnum) && tile > 0
          # if we've found all the bombs we can reveal unrevealed tiles
          flagged_count = neighbors.count {|v, _| v == :f}
          if flagged_count == tile
            neighbors.each do |v, pos|
              add_to_stack(pos, :reveal) if v == :o
            end
          end
          # if there are as many unrevealed neighbors as the value they're all bombs
          unrev_count = neighbors.count {|v, _| v == :f || v == :o}
          if unrev_count == tile
            neighbors.each do |v, pos|
              add_to_stack(pos, :flag) if v == :o
            end
          end
        end
        unrevealed << [i, j] if tile == :o
      end
    end

    add_to_stack(unrevealed.sample, :reveal) if @move_stack.empty?
  end
end
