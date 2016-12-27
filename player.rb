class Player
  ACTIONS = {
  "flag" => :flag,
  "f" => :flag,
  "reveal" => :reveal,
  "r" => :reveal,
  "unflag" => :unflag,
  "u" => :unflag
  }

  def initialize(name=nil)
    @name = name.nil? ? "Outis" : name
  end

  def get_move(board)

  end
end

class HumanPlayer < Player
  def get_move(board)
    pos = get_pos
    action = get_action
    [pos, action]
  end

  def get_pos
    puts "Enter a position."
    gets.chomp.split(",").map(&:to_i)
  end

  def get_action
    puts "Enter 'reveal', 'flag', or 'unflag'."
    ACTIONS[gets.chomp]
  end
end
