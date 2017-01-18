require_relative 'board'
require_relative 'sat_solver'

class SmartBoard < Board

  def reveal(pos)
    i, j = pos
    solver = MinesweeperSatSolver.new(public_grid)
    if self[pos].is_bomb? && solver.solve(i, j, false)
      # re-locate the bombs!
      grid.each_with_index do |row, i|
        row.each_with_index do |tile, j|
          unless tile.revealed
            self[[i, j]] = Tile.new(solver.get_solution_value(i, j))
          end
        end
      end
      populate_counts
    end
    super
  end

end
