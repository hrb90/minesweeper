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
    interior_positions = []
    num_interior_bombs = @num_bombs
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        unless tile.revealed
          pos = [i, j]
          if no_revealed_neighbors?(pos)
            interior_positions << pos
          else
            is_bomb = solver.get_solution_value(i, j)
            num_interior_bombs -= 1 if is_bomb
            self[pos] = Tile.new(is_bomb)
          end
        end
      end
    end
    populate_interior!(interior_positions, num_interior_bombs)
    populate_counts
  end

  def no_revealed_neighbors?(pos)
    get_neighbors(pos)
      .map { |new_pos| self[new_pos] }
      .none? { |tile| tile.revealed }
  end

  def populate_interior!(positions, num_bombs)
    positions.shuffle!
    positions.each_with_index do |pos, i|
      self[pos] = Tile.new(i < num_bombs)
    end
  end

end
