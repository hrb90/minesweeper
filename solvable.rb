module Solvable
  DELTAS = [[-1, -1],
            [-1, 0],
            [-1, 1],
            [0, -1],
            [0, 1],
            [1, -1],
            [1, 0],
            [1, 1]
          ]

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

  def is_number?(tile)
    tile.is_a?(Fixnum) && tile > 0
  end

  def generate_basic_moves(grid)
    moves = []
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        neighbors = get_neighbors(grid, i, j)
        if is_number?(tile)
          moves = moves + get_neighbor_moves(tile, neighbors)
        end
      end
    end
    moves
  end

  def get_neighbor_moves(tile, neighbors)
    moves = []
    # if we've found all the bombs we can reveal unrevealed tiles
    flagged_count = neighbors.count {|v, _| v == :f}
    unrev_count = neighbors.count {|v, _| v == :f || v == :o}
    if flagged_count == tile
      move = :reveal
    elsif unrev_count == tile
      move = :flag
    else
      return moves
    end
    neighbors.each do |v, pos|
      moves << [pos, move] if v == :o
    end
    moves
  end

  def unrevealed(grid)
    unrev = []
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        unrev << [i, j] if tile == :o
      end
    end
    unrev
  end

  def random_move(grid)
    debugger
    [[unrevealed(grid).sample, :reveal]]
  end
end
