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
    return "F" if flagged
    return "*" unless revealed
    return "_" if empty?
    return "B" if is_bomb?
    value.to_s
  end
end
