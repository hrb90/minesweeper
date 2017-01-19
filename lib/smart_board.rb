require_relative 'board'
require_relative 'sat_solver'

class SmartBoard < Board

  def reveal(pos)
    if self[pos].is_bomb?
      # Is it possible that there isn't a bomb at pos?
      # (Given what the player already knows)
      solver = MinesweeperSatSolver.new(public_grid)
      i, j = pos
      return super unless solver.solve(i, j, false)
      rearrange_bombs!(solver)
    end
    super
  end

  private

  def rearrange_bombs!(solver)
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        unless tile.revealed
          self[[i, j]] = Tile.new(solver.get_solution_value(i, j))
        end
      end
    end
    populate_counts
  end

end
