require_relative 'tile'

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(9) {Array.new(9)}
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

  def reveal(pos)
    unless self[pos].revealed
      self[pos].reveal
      if self[pos].empty?
        get_neighbors(pos).each {|neighbor| reveal(neighbor)}
      end
    end
    self[pos].is_bomb?
  end

  def flag(pos)
    self[pos].flag
    false
  end

  def populate
    populate_bombs
    populate_counts
  end

  def populate_bombs
    tile_values = [true] * 10 + [false] * 71
    tile_values.shuffle!
    grid.each_with_index do |row, i|
      row.each_with_index do |pos, j|
        grid[i][j] = Tile.new(tile_values.shift)
      end
    end
  end

  def populate_counts
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        tile.value = count_bomb_neighbors([i, j]) unless tile.is_bomb?
      end
    end
  end

  def count_bomb_neighbors(pos)
    count = 0
    get_neighbors(pos).each do |new_pos|
      count += 1 if self[new_pos].is_bomb?
    end
    count
  end

  def valid_pos?(pos)
    pos.none? { |x| x < 0 || x > 8 }
  end

  def get_neighbors(pos)
    x,y = pos
    neighbors = []
    [-1,0,1].each do |x_off|
      [-1,0,1].each do |y_off|
        new_pos = [x + x_off, y + y_off]
        neighbors << new_pos if valid_pos?(new_pos) && pos != new_pos
      end
    end
    neighbors
  end

  def won?
    grid.each do |row|
      row.each do |tile|
        return false unless tile.revealed || tile.is_bomb?
      end
    end
    true
  end

  def render
    grid.each do |row|
      puts row.join(" ")
    end
  end
end
