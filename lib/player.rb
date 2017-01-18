require 'remedy'
require 'byebug'
require_relative 'tile'
require_relative 'solvable'

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

  def render(grid)
    system "clear"
    grid.map(&:dup).each do |row|
      puts row.map { |x| Tile.sym_to_txt(x) }.join
    end
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
    grid_copy = grid.map(&:dup)
    unless cursor_pos.nil?
      x, y = cursor_pos
      grid_copy[x][y] = :c
    end
    super(grid_copy)
  end
end

class ComputerPlayer < Player
  include Solvable

  def initialize(name=nil)
    super
    @move_stack = []
  end

  def get_move(grid)
    render(grid)
    sleep(0.2)
    add_to_stack(generate_moves(grid)) if @move_stack.empty?
    @move_stack.pop
  end

  def generate_moves(grid)
    basic_moves = generate_basic_moves(grid)
    return basic_moves unless basic_moves.empty?
    sat_moves = generate_sat_moves(grid)
    return sat_moves unless sat_moves.empty?
    random_move(grid)
  end

  def add_to_stack(arr)
    arr.each do |pos, action|
      @move_stack << [pos, action] unless @move_stack.include?([pos, action])
    end
  end
end
