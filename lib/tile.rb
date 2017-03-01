require 'colorize'

class Tile
  attr_accessor :value, :cursor
  attr_reader :revealed, :flagged

  SYMBOL_TO_TEXT = {:c => " ".colorize(:background => :light_green), #cursor
                    :f => "F".colorize(:light_red), #flag
                    :o => "*".colorize(:black), #unrevealed
                    :b => "B".colorize(:black), #bomb
                    0 => "_".colorize(:white),
                    1 => "1".colorize(:blue),
                    2 => "2".colorize(:green),
                    3 => "3".colorize(:red),
                    4 => "4".colorize(:magenta),
                    5 => "5".colorize(:yellow),
                    6 => "6".colorize(:cyan),
                    7 => "7".colorize(:cyan),
                    8 => "8".colorize(:cyan)}

  def initialize(is_bomb)
    @value = is_bomb ? :b : nil
    @revealed = false
    @flagged = false
    @cursor = false
  end

  def self.sym_to_txt(symbol)
    SYMBOL_TO_TEXT[symbol]
  end

  # Populates grid with tiles, n_bombs of which are bombs.
  def self.populate(grid, n_bombs=nil)
    n_bombs ||= grid.flatten.length/8
    bomb_locs = [false] * grid.flatten.length
    n_bombs.times { |i| bomb_locs[i] = true }
    bomb_locs.shuffle!
    grid.each do |row|
      row.length.times { |i| row[i] = Tile.new(bomb_locs.pop)}
    end
  end

  def reveal
    @revealed = true
    unflag
  end

  def flag
    @flagged = true
  end

  def unflag
    @flagged = false
  end

  def empty?
    value == 0
  end

  def is_bomb?
    value == :b
  end

  def to_s
    self.class.sym_to_txt(to_symbol)
  end

  def to_symbol
    # The order of the returns matters!
    return :c if cursor
    return :f if flagged
    return :o unless revealed
    return :b if is_bomb?
    value
  end
end
