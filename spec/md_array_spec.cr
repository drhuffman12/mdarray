require "./spec_helper"

Spectator.describe MdArray do
  describe "MdArrayF64" do
    # before(:all) do
    #   MdAF64 = MdArrayF64
    # end

    # before(:each) do
    # end

    context "when given a small MdArray params" do
      let(mdarray) { MdArrayF64.new(dims_expected, rand_seed: false) }
      let(dims_expected) { [1,1] }
      let(qty_cells_expected) { 1 }
      let(cells_expected) { [0.0] }
      let(mda_inspect_expected) { [[0.0]] }

      describe "DEBUG" do
        it "DEBUG mdarray" do
          p! mdarray
        end
      end

      describe "#initialize" do
        context "sets the instance variable as expected for" do
          it "dims" do
            expect(mdarray.dims).to eq(dims_expected)
          end

          it "qty_cells" do
            expect(mdarray.qty_cells).to eq(qty_cells_expected)
          end

          it "cells" do
            expect(mdarray.cells).to eq(cells_expected)
          end
        end
      end

      describe "inspect" do
        it "returns" do
          expect(mdarray.mda_inspect).to eq(mda_inspect_expected)
        end
      end

      describe "validate_ordinates" do
        let(ords_dim_ok) { [0,0] }
        let(ords_dim_mismatch) { [1,1,1] }
        let(ords_oob_mismatch) { [2,3] }
        
        context "returns true when given" do
          context "ords_dim_ok" do
            it "returns" do
              expect(mdarray.errors).to eq(MdArrayF64::Errors.new)
              expect(mdarray.valid?).to eq(true)
              checks = mdarray.validate_ordinates(ords_dim_ok)
              expect(mdarray.errors).to eq(MdArrayF64::Errors.new)
              expect(mdarray.valid?).to eq(true)
              expect(mdarray.errors).to be_empty
              expect(checks).to be_empty
            end
          end
        end

        context "returns false when given" do
          context "dim_mismatch" do
            let(error_key_expected) { "ordinates.invalid.dim_mismatch" }

            it "returns" do
              # expect(mdarray.validate_ordinates(ords_dim_mismatch)).to raise_error(MdArrayF64::OrdinateDimMismatch)

              expect(mdarray.errors).to eq(MdArrayF64::Errors.new)
              expect(mdarray.valid?).to eq(true)
              checks = mdarray.validate_ordinates(ords_dim_mismatch)
              # expect(mdarray.errors).to eq(MdArrayF64::Errors.new)
              expect(mdarray.errors).to have_key(error_key_expected)
              expect(mdarray.valid?).to eq(false)
              expect(mdarray.errors).not_to be_empty
              expect(checks).not_to be_empty
            end
          end

          context "oob_mismatch" do
            let(error_key_expected) { "ordinates.invalid.oob" }
            
            it "returns" do
              # expect(mdarray.validate_ordinates(ords_oob_mismatch)).to raise_error(MdArrayF64::OrdinateOutOfBounds)

              expect(mdarray.errors).to eq(MdArrayF64::Errors.new)
              expect(mdarray.valid?).to eq(true)
              checks = mdarray.validate_ordinates(ords_oob_mismatch)
              # expect(mdarray.errors).to eq(MdArrayF64::Errors.new)
              expect(mdarray.errors).to have_key(error_key_expected)
              expect(mdarray.valid?).to eq(false)
              expect(mdarray.errors).not_to be_empty
              expect(checks).not_to be_empty
            end
          end
        end
      end

      describe "at" do
        describe "when given an in-bounds ordinate" do
          let(ord_in_bounds) { [0,0] }
          let(value_expected) { 0.0 }

          it "returns" do
            expect(mdarray.at(ord_in_bounds)).to eq(value_expected)
          end
        end

        describe "when given an out-of-bounds ordinate" do
          let(ord_out_of_bounds) { [rand(2)*2-1,rand(2)*2-1] }
          let(value_expected) { [0.0] }

          it "returns" do
            expect{
              expect(mdarray.at(ord_out_of_bounds))
          }.to raise_error(MdArrayF64::OrdinateError)
          end
        end
      end
    end

    context "when given a medium MdArray params" do
      let(dims_expected) { [2,3] }
      let(mdarray) { MdArrayF64.new(dims_expected, rand_seed: false) }
      let(qty_cells_expected) { 6 }
      let(cells_expected) { [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] }
      let(mda_inspect_expected) { [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]] }

      context "#initialize" do
        context "sets the instance variable as expected for" do
          it "dims" do
            expect(mdarray.dims).to eq(dims_expected)
          end

          it "qty_cells" do
            expect(mdarray.qty_cells).to eq(qty_cells_expected)
          end

          it "cells" do
            expect(mdarray.cells).to eq(cells_expected)
          end
        end
      end
    end

    context "when given a bigger MdArray params" do
      let(dims_expected) { [4,3,2] }
      let(mdarray) { MdArrayF64.new(dims_expected, rand_seed: false) }
      # let(mdarray) { MdArrayF64.new(dims_expected, rand_seed: true) }
      let(qty_cells_expected) { 24 }
      # [[[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]], [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]], [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]], [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]]
      let(cells_expected) {
        [
          0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
          0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
          0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
          0.0, 0.0, 0.0, 0.0, 0.0, 0.0
        ]
      }
      let(mda_inspect_expected) { [[0.0]] }

      describe "DEBUG" do
        it "DEBUG mdarray" do
          p! mdarray
        end
      end

      context "#initialize" do
        context "sets the instance variable as expected for" do
          it "dims" do
            expect(mdarray.dims).to eq(dims_expected)
          end

          it "qty_cells" do
            expect(mdarray.qty_cells).to eq(qty_cells_expected)
          end

          it "cells" do
            expect(mdarray.cells).to eq(cells_expected)
          end
        end
      end
    end

  end
end
