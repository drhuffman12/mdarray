require "./spec_helper"

Spectator.describe MdArray do
  describe "initialize" do
    context "initializes with defaults" do
      let(mdarray) { MdArray.new }
      let(qty_cells_expected) { 1 }
      let(dims_expected) { [1,1] }
      let(seeds_expected) { [0.0] }
      let(cells_expected) {
        [
          [0.0]
        ].flatten
      }
      it "qty_cells" do
        expect(mdarray.qty_cells).to eq(qty_cells_expected)
      end

      it "dims" do
        expect(mdarray.dims).to eq(dims_expected)
      end

      it "seeds" do
          expect(mdarray.cells).to eq(cells_expected)
      end

      it "cells" do
        expect(mdarray.cells).to eq(cells_expected)
      end

      pending "seeds_block" do
        # expect(mdarray.qty_cells).to eq(qty_cells_expected)
      end
    end

    context "initializes with non-defaults" do
      context "with dims of [2,3] and seeds given of 3.0" do
        let(dims_given) { [2,3] }
        let(seeds_given) { [1.0, 2.0, 3.0] }
        let(mdarray) { MdArray.new(dims: dims_given, seeds: seeds_given)  }
        let(qty_cells_expected) { 6 }
        let(dims_expected) { dims_given }
        let(seeds_expected) { seeds_given }
        let(cells_expected) {
          [
            [1.0,2.0,3.0],
            [1.0,2.0,3.0]
          ].flatten
        }
        it "qty_cells" do
          expect(mdarray.qty_cells).to eq(qty_cells_expected)
        end

        it "dims" do
          expect(mdarray.dims).to eq(dims_expected)
        end

        it "seeds" do
          expect(mdarray.seeds).to eq(seeds_expected)
        end

        it "cells" do
          expect(mdarray.seeds).to eq(seeds_expected)
        end

        it "cells" do
          expect(mdarray.cells).to eq(cells_expected)
        end

        pending "seeds_block" do
          # expect(mdarray.qty_cells).to eq(qty_cells_expected)
        end
      end

      context "with dims of [1,1]" do
        let(dims_given) { [3,4,5] }
        let(seeds_given) { [0.125] }
        let(mdarray) { MdArray.new(dims: dims_given, seeds: seeds_given)  }
        let(qty_cells_expected) { 60 }
        let(dims_expected) { dims_given }
        let(seeds_expected) { seeds_given }
        let(cells_expected) {
          [
            [
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125]
            ],
            [
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125]
            ],
            [
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125],
              [0.125,0.125,0.125,0.125,0.125]
            ]
          ].flatten
        }
        it "qty_cells" do
          expect(mdarray.qty_cells).to eq(qty_cells_expected)
        end

        it "dims" do
          expect(mdarray.dims).to eq(dims_expected)
        end

        it "seeds" do
          expect(mdarray.seeds).to eq(seeds_expected)
        end

        it "cells" do
          expect(mdarray.cells).to eq(cells_expected)
        end

        pending "seeds_block" do
          # expect(mdarray.qty_cells).to eq(qty_cells_expected)
        end
      end
    end
  end
end
