require 'solvable'

class SolvableWrapper
  include Solvable
end

describe 'Solvable' do
  subject (:solver) { SolvableWrapper.new }
  let(:basic_grid) do
    [Array.new(4) { 0 },
     Array.new(4) { 0 },
     [0, 1, 1, 1],
     [0, 1, :o, :o]]
  end

  describe "#generate_basic_moves" do
    it "finds basic moves" do
      expect(solver.generate_basic_moves(basic_grid)).to eq(
      [
        [[3, 2], :flag]
      ]
      )
    end
  end

  describe "#generate_sat_moves" do
    let(:sat_grid) do
      [Array.new(5) { :o },
      Array.new(5) { :o },
      Array.new(5) { :o },
      [:o, 1, 1, 1, 1],
      [:o, 1, 0, 0, 0]]
    end

    let(:hard_grid) do
      [[:o, :o, :o, :o, :o, :o],
       [:o, 2, 2, 2, 2, :o],
       [:o, 2, 0, 0, 2, :o],
       [:o, 2, 0, 0, 2, :o],
       [:o, 2, 2, 2, 2, :o],
       [:o, :o, :o, :o, :o, :o]]
    end

    it "finds basic moves" do
      expect(solver.generate_sat_moves(basic_grid)).to eq(
      [
        [[3, 2], :flag],
        [[3, 3], :reveal]
      ]
      )
    end

    it "finds complicated moves" do
      expect(solver.generate_sat_moves(sat_grid).sort).to eq(
      [
        [[2, 0], :reveal],
        [[2, 1], :reveal],
        [[2, 2], :reveal],
        [[2, 3], :flag],
        [[2, 4], :reveal]
      ]
      )
    end

    it "finds all the moves" do
      expect(solver.generate_sat_moves(hard_grid).length).to eq(20)
    end

  end

end
