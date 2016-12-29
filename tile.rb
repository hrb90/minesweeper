require 'colorize'

class Tile
  attr_accessor :value
  attr_reader :revealed, :flagged

  SYMBOL_TO_TEXT = {:f => "F".colorize(:light_red),
                    :o => "*".colorize(:black),
                    :b => "B".colorize(:black),
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
  end

  def self.sym_txt(symbol)
    SYMBOL_TO_TEXT[symbol]
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
    SYMBOL_TO_TEXT[to_symbol]
  end

  def to_symbol
    return :f if flagged
    return :o unless revealed
    return :b if is_bomb?
    value
  end
end
