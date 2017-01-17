require 'solvable'

class SolvableWrapper
  include Solvable
end

describe 'Solvable' do
  subject (:solver) { SolvableWrapper.new }
  let(:sat_grid) do
    [Array.new(5) { :o },
    Array.new(5) { :o },
    Array.new(5) { :o },
    [:o, 1, 1, 1, 1],
    [:o, 1, 0, 0, 0]]
  end

  it "finds complicated moves" do
    expect(solver.generate_sat_moves(sat_grid).sort).to eq(
    [
      [[2, 0], :reveal],
      [[2, 1], :reveal],
      [[2, 2], :reveal],
      [[2, 3], :flag],
      [[2, 4], :reveal]
    ])
  end
end
