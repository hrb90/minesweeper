require_relative 'sat_solver'
require 'byebug'

module Solvable
  include GridHelper

  def generate_basic_moves(grid)
    moves = []
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        if is_number?(tile)
          moves = moves + get_neighbor_moves(grid, i, j)
        end
      end
    end
    moves.uniq
  end

  def get_neighbor_moves(grid, x, y)
    moves = []
    if neighbor_bombs_flagged?(grid, x, y)
      move = :reveal
    elsif all_neighbors_bombs?(grid, x, y)
      move = :flag
    else
      return moves
    end
    get_neighbors(grid, x, y).each do |v, pos|
      moves << [pos, move] if v == :o
    end
    moves
  end

  def generate_sat_moves(grid)
    moves = []
    solver = MinesweeperSatSolver.new(grid)
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        moves << [[i, j], :reveal] unless solver.solve(i, j, true)
        moves << [[i, j], :flag] unless solver.solve(i, j, false)
      end
    end
    moves.reject do |pos, val|
      i, j = pos
      val == :flag && grid[i][j] == :f or val == :reveal && grid[i][j] != :o
    end
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
    [[unrevealed(grid).sample, :reveal]]
  end
end
