require 'colorize'

class Tile
  attr_accessor :value
  attr_reader :revealed, :flagged

  def initialize(is_bomb)
    @value = is_bomb ? :b : nil
    @revealed = false
    @flagged = false
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
    get_string.colorize(get_color)
  end

  def get_string
    return "F" if flagged
    return "*" unless revealed
    return "_" if empty?
    return "B" if is_bomb?
    value.to_s
  end

  def get_color
    return :light_red if flagged
    return :black unless revealed
    return :white if empty?
    return :black unless value.is_a?(Fixnum)
    case value
    when 1
      :blue
    when 2
      :green
    when 3
      :red
    when 4
      :magenta
    when 5
      :yellow
    else
      :cyan
    end
  end
end
