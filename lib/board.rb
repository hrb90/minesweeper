require_relative 'tile'

class Board
  attr_reader :num_bombs

  def initialize(rows = 9, cols = 9, num_bombs = nil)
    @rows = rows
    @cols = cols
    num_bombs ||= get_num_bombs
    @num_bombs = num_bombs
    @grid = Array.new(rows) {Array.new(cols)}
  end

  def reveal_bombs
    grid.flatten.each do |tile|
      if tile.is_bomb? && won?
        tile.flag
      elsif tile.is_bomb?
        tile.reveal
      end
    end
  end

  # reveal, flag, and unflag all return whether the game is over
  def reveal(pos)
    unless self[pos].revealed
      self[pos].reveal
      if self[pos].empty?
        get_neighbors(pos).each { |neighbor| reveal(neighbor) }
      end
    end
    self[pos].is_bomb?
  end

  def flag(pos)
    self[pos].flag
    @num_bombs += 1
    false
  end

  def unflag(pos)
    self[pos].unflag
    @num_bombs -= 1
    false
  end

  def populate
    populate_bombs
    populate_counts
  end

  def populate_bombs
    Tile.populate(grid, num_bombs)
  end

  def populate_counts
    grid.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        tile.value = count_bomb_neighbors([i, j]) unless tile.is_bomb?
      end
    end
  end

  def count_bomb_neighbors(pos)
    get_neighbors(pos).count { |pos| self[pos].is_bomb? }
  end

  def valid_pos?(pos)
    x, y = pos
    (0...rows).include?(x) && (0...cols).include?(y)
  end

  def won?
    grid.flatten.each do |tile|
      return false unless tile.revealed || tile.is_bomb?
    end
    true
  end

  # expo
  def public_grid
    grid.map do |row|
      row.map(&:to_symbol)
    end
  end

  private

  attr_reader :grid, :rows, :cols

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

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    grid[row][col] = val
  end

  def get_num_bombs
    rows * cols / 8
  end
end
