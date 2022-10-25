require "./../spec_helper"

Spectator.describe MdArray::MdArrayF64 do
  context "when given a (medium) MdArray params" do
    # All changes go here!
    let(dims_expected) { [2, 3, 4] }
    let(qty_cells_expected) { 24 }

    let(cells_expected) {
      [
        0.0, 0.0,
        0.0, 0.0,
        0.0, 0.0,

        0.0, 0.0,
        0.0, 0.0,
        0.0, 0.0,

        0.0, 0.0,
        0.0, 0.0,
        0.0, 0.0,

        0.0, 0.0,
        0.0, 0.0,
        0.0, 0.0,
      ]
    }
    let(mda_inspect_expected) {
      [
        "[[[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]",
        " [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]",
        " [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]",
        " [[0.0, 0.0], [0.0, 0.0], [0.0, 0.0]]]",
      ].join
    }
    let(ords_for_value) { [1, 2, 3] }
    let(index_expected) { 18 }
    let(value_expected_for_ords) { 18.0 }

    let(ords_at_in_order) {
      i = 0
      d2is = (0..dims_expected[2] - 1).to_a.map do |d2|
        d1is = (0..dims_expected[1] - 1).to_a.map do |d1|
          d0is = (0..dims_expected[0] - 1).to_a.map do |d0|
            i_ords = {i => [d0, d1, d2]}
            i += 1
            i_ords
          end
        end
      end.flatten
    }
    let(indexes_for_in_order) {
      ords_at_in_order.map { |ords| mdarray.index_for(ords.values.first) }
    }
    let(ords_expected) {
      [
        {0 => [0, 0, 0]}, {1 => [1, 0, 0]}, {2 => [0, 1, 0]}, {3 => [1, 1, 0]},
        {4 => [0, 2, 0]}, {5 => [1, 2, 0]}, {6 => [0, 0, 1]}, {7 => [1, 0, 1]},
        {8 => [0, 1, 1]}, {9 => [1, 1, 1]}, {10 => [0, 2, 1]}, {11 => [1, 2, 1]},
        {12 => [0, 0, 2]}, {13 => [1, 0, 2]}, {14 => [0, 1, 2]}, {15 => [1, 1, 2]},
        {16 => [0, 2, 2]}, {17 => [1, 2, 2]}, {18 => [0, 0, 3]}, {19 => [1, 0, 3]},
        {20 => [0, 1, 3]}, {21 => [1, 1, 3]}, {22 => [0, 2, 3]}, {23 => [1, 2, 3]},
      ]
    }
    let(values_at_in_order) {
      ords_at_in_order.map { |ords| mdarray.at(ords.values.first) }
    }
    let(values_expected) { [
      0.0, 1.0, 2.0, 3.0, 4.0, 5.0,
      6.0, 7.0, 8.0, 9.0, 10.0, 11.0,
      12.0, 13.0, 14.0, 15.0, 16.0, 17.0,
      18.0, 19.0, 20.0, 21.0, 22.0, 23.0,
    ] }

    # Shouldn't have to change anything below!
    let(mdarray) { MdArray::MdArrayF64.new(dims_expected, rand_seed: false) }
    let(ords_in_bounds) { dims_expected.map { |d| d - 1 } }

    let(ords_dim_mismatch) {
      dims_expected.map { |d| rand(d) } + [0]
    }
    let(ords_oob_mismatch) {
      dims_expected.map { |d| [-1, d].sample }
    }
    let(error_key_dim_mismatch_expected) { "ordinates.invalid.dim_mismatch" }
    let(error_key_oob_expected) { "ordinates.invalid.oob" }

    context "common tests" do
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

      # describe "mda_inspect" do
      #   skip "returns" do
      #     expect(mdarray.mda_inspect).to eq(mda_inspect_expected)
      #   end
      # end

      describe "validate_ordinates" do
        context "returns true when given" do
          context "ords_in_bounds" do
            it "returns" do
              expect(mdarray.errors).to eq(MdArray::MdArrayF64::Errors.new)
              expect(mdarray.valid_ordinates?).to eq(true)
              checks = mdarray.validate_ordinates(ords_in_bounds)
              expect(mdarray.errors).to eq(MdArray::MdArrayF64::Errors.new)
              expect(mdarray.valid_ordinates?).to eq(true)
              expect(mdarray.errors).to be_empty
              expect(checks).to be_empty
            end
          end
        end

        context "returns false when given" do
          context "dim_mismatch" do
            it "returns" do
              expect(mdarray.errors).to eq(MdArray::MdArrayF64::Errors.new)
              expect(mdarray.valid_ordinates?).to eq(true)
              checks = mdarray.validate_ordinates(ords_dim_mismatch)

              p! mdarray.errors

              expect(mdarray.errors).to have_key(error_key_dim_mismatch_expected)
              expect(mdarray.valid_ordinates?).to eq(false)
              expect(mdarray.errors).not_to be_empty
              expect(checks).not_to be_empty
            end
          end

          context "oob_mismatch" do
            it "returns" do
              expect(mdarray.errors).to eq(MdArray::MdArrayF64::Errors.new)
              expect(mdarray.valid_ordinates?).to eq(true)

              checks = mdarray.validate_ordinates(ords_oob_mismatch)

              expect(mdarray.errors).to have_key(error_key_oob_expected)
              expect(mdarray.valid_ordinates?).to eq(false)
              expect(mdarray.errors).not_to be_empty
              expect(checks).not_to be_empty
            end
          end
        end
      end

      describe "index_for" do
        describe "when given an in-bounds ordinate" do
          skip "returns" do
            p! [mdarray.dims, ords_in_bounds]

            expect(mdarray.index_for(ords_in_bounds)).to eq(index_expected)
          end
        end

        describe "when given an bad dim'd ordinate" do
          it "returns" do
            p! [mdarray.dims, ords_dim_mismatch]
            expect {
              mdarray.index_for(ords_dim_mismatch)
            }.to raise_error(MdArray::MdArrayF64::OrdinateError)
          end
        end

        describe "when given an out-of-bounds ordinate" do
          it "returns" do
            p! [mdarray.dims, ords_oob_mismatch]
            expect {
              mdarray.index_for(ords_oob_mismatch)
            }.to raise_error(MdArray::MdArrayF64::OrdinateError)
          end
        end
      end

      describe "at" do
        describe "when given an in-bounds ordinate" do
          skip "returns" do
            p! [mdarray.dims, ords_in_bounds]

            expect(mdarray.at(ords_in_bounds)).to eq(value_expected_for_ords)
          end
        end

        describe "when given an out-of-bounds ordinate" do
          it "returns" do
            p! [mdarray.dims, ords_oob_mismatch]
            expect {
              mdarray.at(ords_oob_mismatch)
            }.to raise_error(MdArray::MdArrayF64::OrdinateError)
            expect(mdarray.errors).to have_key(error_key_oob_expected)
          end
        end
      end
    end

    context "unique tests" do
      describe "index_for" do
        describe "dims in order" do
          before_all do
            puts "/ndims in order/n"
          end
          it "indexes" do
            p! ords_at_in_order
            p! indexes_for_in_order
            expect(ords_at_in_order).to eq(ords_expected)
          end
        end
      end

      describe "at" do
        describe "dims in order" do
          before_all do
            puts "/nat/n"
          end
          let(cells_expected) {
            (0..qty_cells_expected - 1).to_a.map(&.to_f64)
          }
          before_each do
            p! mdarray.cells
            mdarray.cells = cells_expected
            p! mdarray.cells
          end
          it "indexes" do
            # p! ords_expected
            # p! ords_at_in_order
            expect(ords_at_in_order).to eq(ords_expected)
          end
          it "values" do
            p! values_expected
            p! values_at_in_order
            # p! [values_expected, values_at_in_order]
            expect(values_at_in_order).to eq(values_expected)
          end
        end
      end

      describe "set(i, v : Float64)" do
        # TODO
      end

      describe "set(i, values : Array(Float64))" do
        # TODO
      end

      describe "fix_indexes(i)" do
        # TODO
      end

      describe "index_too_big(i)" do
        # TODO
      end

      describe "index_too_small(i)" do
        # TODO
      end
    end
  end
end
