module GridHelper
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

  def neighbor_bombs_flagged?(grid, x, y)
    get_neighbors(grid, x, y).count { |v, _| v == :f } == grid[x][y]
  end

  def all_neighbors_bombs?(grid, x, y)
    get_neighbors(grid, x, y).count { |v, _| v == :f || v == :o } == grid[x][y]
  end

  def valid_pos?(grid, x, y)
    x >= 0 && x < grid.length && y >= 0 && y < grid[0].length
  end
end
