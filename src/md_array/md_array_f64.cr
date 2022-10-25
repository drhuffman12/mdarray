module MdArray
  class MdArrayF64 # < Array(U)
    alias NestedArray = Array(Float64) | Array(NestedArray)
    alias Ordinates = Array(Int32)

    class OrdinateError < Exception; end

    class OrdinateDimMismatch < OrdinateError; end

    class OrdinateOutOfBounds < OrdinateError; end

    class Errors < Hash(String, OrdinateError); end

    property errors = Errors.new

    getter qty_cells : Int32 = 1 # = 0_u64
    getter dims : Array(Int32) = [1, 1]
    property cells : Array(Float64) # : StaticArray
    property default_value : Float64

    def initialize(@dims : Array(Int32) = [1, 1], @default_value = Float64.new(0), @rand_seed = true) # , @seeds = [0.0])
      @qty_cells = dims.product(1).to_i32
      @cells = Array(Float64).new(@qty_cells, @default_value)
      @cells.map! { rand } if @rand_seed
    end

    def index_for(ordinates : Ordinates)
      validate_ordinates(ordinates)

      unless valid_ordinates?
        raise OrdinateError.new("ordinates.invalid: [#{errors.keys.map { |k| k[0..16] == "ordinates.invalid" }.join(", ")}]")
      end

      # ordinates: [1,2,1] => 1 + 2*1 + 2*3*1 == 1 + 4 + 6 == 11
      factor = 1
      sum = 0

      ordinates.each_with_index do |ord, i|
        sum += factor * ord
        factor = factor * dims[i]
      end

      sum
    end

    def ordinates_for(index : Ordinates)
      # ordinates => index: [1,2,1] => 1 + 2*1 + 2*3*1 == 1 + 4 + 6 == 11
      # index => ordinates: 11 =>  1 + 4 + 6 == 1 + 2*1 + 2*3*1 == 1,2,1]

      # TODO: inverse of "#index_for"
    end

    def at(ordinates : Ordinates)
      index = index_for(ordinates)
      if index > cells.size - 1
        msg = [
          "index > cells.size - 1; index: #{index}",
          " cells.size - 1 : #{cells.size - 1}",
          " ordinates: #{ordinates}"
        ].join
        raise OrdinateOutOfBounds.new(msg)
      end
      cells[index]
    end

    def validate_ordinates(ordinates : Ordinates)
      @errors.clear

      if ordinates.size != dims.size
        msg = [
          "ordinates: #{ordinates} vs dims: #{dims}",
          " comparing ords size vs dims size: #{ordinates.size} vs #{dims.size}"
        ].join
        @errors["ordinates.invalid.dim_mismatch"] = OrdinateDimMismatch.new(msg)
      else
        ord_oob_which = dims.map_with_index do |dmax, i|
          case
          when ordinates[i] < 0
            -1
          when ordinates[i] >= dmax
            1
          else
            0
          end
        end
        ord_oob = ord_oob_which.map { |oob| oob != 0 }
        ord_oob_any = !ord_oob.empty?

        @errors["ordinates.invalid.oob"] = OrdinateOutOfBounds.new("ord_oob_which: #{ord_oob_which}") if ord_oob_any
      end

      @errors
    end

    def valid_ordinates?
      errors.nil? || errors.empty?
    end
  end
end
