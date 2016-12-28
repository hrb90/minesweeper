class Player
  ACTIONS = {
  "flag" => :flag,
  "f" => :flag,
  "reveal" => :reveal,
  "r" => :reveal,
  "unflag" => :unflag,
  "u" => :unflag
  }

  def initialize(name=nil)
    @name = name.nil? ? "Outis" : name
  end

  def get_move(board)

  end
end

class HumanPlayer < Player
  def get_move(grid)
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
    @name = name.nil? ? "Outis" : name
    @move_stack = []
  end

  def get_move(grid)
    sleep(0.5)
    return @move_stack.pop unless @move_stack.empty?
    generate_moves(grid)
    @move_stack.pop
  end

  def valid_pos?(grid, x, y)
    (0...grid.length).include?(x) && (0...grid[0].length).include?(y)
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
