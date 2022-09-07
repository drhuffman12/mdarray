require "./spec_helper"

Spectator.describe MdArray do
  # example data set 1
  let(mdarray1) { MdArray.new }
  let(qty_cells_expected1) { 1 }
  let(dims_expected1) { [1, 1] }
  let(dim_factors1) { [1, 1] }
  let(seeds_expected1) { [[0.0]] }
  let(cells_expected1) {
    [
      [0.0],
    ].flatten
  }

  # example data set 2
  let(dims_given2) { [2, 3] }
  let(dim_factors2) { [1, 2] }
  let(seeds_given2) { [1.0, 2.0, 3.0] }
  let(mdarray2) { MdArray.new(dims: dims_given2, seeds: seeds_given2) }
  let(qty_cells_expected2) { 6 }
  let(dims_expected2) { dims_given2 }
  let(seeds_expected2) { seeds_given2 }
  let(cells_expected2) {
    [
      [1.0, 2.0],
      [3.0, 1.0],
      [2.0, 3.0],
    ].flatten
  }

  # example data set 3
  let(dims_given3) { [3, 4, 5] }
  let(dim_factors3) { [1, 3, 12] }
  let(seeds_given3) { [0.0, 0.1, 0.2, 0.3, 0.4] }
  let(mdarray3) { MdArray.new(dims: dims_given3, seeds: seeds_given3) }
  let(qty_cells_expected3) { 60 }
  let(dims_expected3) { dims_given3 }
  let(seeds_expected3) { seeds_given3 }
  let(cells_expected3) {
    # x0..x2
    [
      # y0..y3
      [
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
      ],
      # y0..y3
      [
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
      ],
      # y0..y3
      [
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
        # z0..z4
        [0.0, 0.1, 0.2, 0.3, 0.4],
      ],
    ].flatten
  }

  # # example data set 4
  # let(dims_given4) { [3, 4, 5] }
  # let(dim_factors4) { [1, 3, 12] }
  # let(seeds_given4) { [0.0, 0.1, 0.2, 0.3, 0.4] }
  # let(seeds_block4) {
  #   ->(x : Int32, y : Int32, z : Int32) { x*100 + y*10 + z }
  # }
  # let(mdarray4) {
  #   MdArray.new(dims: dims_given4) { seeds_block4 }
  # }
  # let(qty_cells_expected3) { 60 }
  # let(dims_expected4) { dims_given4 }
  # let(seeds_expected4) { seeds_given4 }
  # let(cells_expected4) {
  #   # x0..x2
  #   [
  #     # y0..y3
  #     [
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #     ],
  #     # y0..y3
  #     [
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #     ],
  #     # y0..y3
  #     [
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #       # z0..z4
  #       [0.0, 0.1, 0.2, 0.3, 0.4],
  #     ],
  #   ].flatten
  # }

  describe "initialize" do
    context "initializes with defaults" do
      it "qty_cells" do
        expect(mdarray1.qty_cells).to eq(qty_cells_expected1)
      end

      it "dims" do
        expect(mdarray1.dims).to eq(dims_expected1)
      end

      it "dim_factors" do
        expect(mdarray1.dim_factors).to eq(dim_factors1)
      end

      it "seeds" do
        expect(mdarray1.cells).to eq(cells_expected1)
      end

      it "cells" do
        expect(mdarray1.cells).to eq(cells_expected1)
      end

      skip "seeds_block" do
        # expect(mdarray1.qty_cells).to eq(qty_cells_expected1)
      end
    end

    context "initializes with non-defaults" do
      context "with dims of [2,3] and seeds given of 3.0" do
        it "qty_cells" do
          expect(mdarray2.qty_cells).to eq(qty_cells_expected2)
        end

        it "dims" do
          expect(mdarray2.dims).to eq(dims_expected2)
        end

        it "dim_factors" do
          expect(mdarray2.dim_factors).to eq(dim_factors2)
        end

        it "seeds" do
          expect(mdarray2.seeds).to eq(seeds_expected2)
        end

        it "cells" do
          expect(mdarray2.seeds).to eq(seeds_expected2)
        end

        it "cells" do
          expect(mdarray2.cells).to eq(cells_expected2)
        end

        skip "seeds_block" do
          # expect(mdarray2.qty_cells).to eq(qty_cells_expected2)
        end
      end

      context "with dims of [1,1]" do
        it "qty_cells" do
          expect(mdarray3.qty_cells).to eq(qty_cells_expected3)
        end

        it "dims" do
          expect(mdarray3.dims).to eq(dims_expected3)
        end

        it "dim_factors" do
          expect(mdarray3.dim_factors).to eq(dim_factors3)
        end

        it "seeds" do
          expect(mdarray3.seeds).to eq(seeds_expected3)
        end

        it "cells" do
          expect(mdarray3.cells).to eq(cells_expected3)
        end

        skip "seeds_block" do
          # expect(mdarray3.qty_cells).to eq(qty_cells_expected3)
        end
      end

      context "with dims of [2,3,4] and seeds given of proc" do
        it "qty_cells" do
          expect(mdarray3.qty_cells).to eq(qty_cells_expected3)
        end

        it "dims" do
          expect(mdarray3.dims).to eq(dims_expected3)
        end

        it "dim_factors" do
          expect(mdarray3.dim_factors).to eq(dim_factors3)
        end

        it "seeds" do
          expect(mdarray3.seeds).to eq(seeds_expected3)
        end

        it "cells" do
          expect(mdarray3.seeds).to eq(seeds_expected3)
        end

        it "cells" do
          expect(mdarray3.cells).to eq(cells_expected3)
        end

        skip "seeds_block" do
          # expect(mdarray3.qty_cells).to eq(qty_cells_expected3)
        end
      end
    end
  end

  describe "get_cell_index" do
    context "using cells_expected2" do
      let(cells_expected) { cells_expected2 }
      context "[0,0]" do
        let(ordinates) { [0, 0] }
        let(expected_value) { 0 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end

      context "[0,1]" do
        let(ordinates) { [0, 1] }
        let(expected_value) { 1 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end

      context "[1,0]" do
        let(ordinates) { [1, 0] }
        let(expected_value) { 2 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end

      context "[1,1]" do
        let(ordinates) { [1, 1] }
        let(expected_value) { 3 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end

      context "[2,0]" do
        let(ordinates) { [2, 0] }
        let(expected_value) { 4 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end

      context "[2,0]" do
        let(ordinates) { [2, 0] }
        let(expected_value) { 4 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end

      context "[2,1]" do
        let(ordinates) { [2, 1] }
        let(expected_value) { 5 }

        it "returnes expected flattened ordinate" do
          expect(mdarray2.get_cell_index(ordinates)).to eq(expected_value)
        end
      end
    end
  end
end
