require_relative 'tile'
require_relative 'solvable'

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
    raise NotImplementedError.new
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
