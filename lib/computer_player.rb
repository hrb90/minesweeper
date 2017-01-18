require_relative 'player'

class ComputerPlayer < Player
  include Solvable

  def initialize(name=nil)
    super
    @move_stack = []
  end

  def get_move(grid)
    render(grid)
    sleep(0.2)
    add_to_stack(generate_moves(grid)) if @move_stack.empty?
    @move_stack.pop
  end

  def generate_moves(grid)
    basic_moves = generate_basic_moves(grid)
    return basic_moves unless basic_moves.empty?
    sat_moves = generate_sat_moves(grid)
    return sat_moves unless sat_moves.empty?
    random_move(grid)
  end

  def add_to_stack(arr)
    arr.each do |pos, action|
      @move_stack << [pos, action] unless @move_stack.include?([pos, action])
    end
  end
end
