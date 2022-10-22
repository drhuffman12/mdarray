# class MdArray(U) # < Array(U)
class MdArrayF64 # < Array(U)
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  alias NestedArray = Array(Float64) | Array(NestedArray)
  alias Ordinates = Array(Int32)

  class OrdinateError < Exception; end
  class OrdinateDimMismatch < OrdinateError; end
  class OrdinateOutOfBounds < OrdinateError; end

  class Errors < Hash(String, OrdinateError); end

  property errors = Errors.new

  getter qty_cells : Int32 = 1         # = 0_u64
  getter dims : Array(Int32) = [1,1]
  property cells : Array(Float64)              # : StaticArray
  property default_value : Float64
  # getter dim_factors : Array(Int32) # = [1,1]
  # getter seeds : Array(Float64)     # = 0_f64

  def initialize(@dims : Array(Int32) = [1, 1], @default_value = Float64.new(0), @rand_seed = true) # , @seeds = [0.0])
    @qty_cells = dims.product(1).to_i32
    @cells = Array(Float64).new(@qty_cells, @default_value)
    @cells.map!{|v| rand} if @rand_seed
  end

  def mda_inspect # : NestedArray
    # @dims.each_with_index do |dim_value, dim_index|

    [[0.0]] # .as(NestedArray) # TODO
    # end
  end

  def nested_array()
    # TODO
  end

  def at(ordinates : Ordinates)
    validate_ordinates(ordinates)

    unless valid?
      raise OrdinateError.new("ordinates.invalid: [#{errors.map{|k,v| k[0..16] == "ordinates.invalid"}.join(", ")}]")
    end

    0.0 # TODO
  end

  # def initialize(@dims : Array(Int32) = [1, 1], @seeds = [0.0])
  #   @qty_cells = dims.product(1).to_i32
  #   @dim_factors = [1] # fake value for initial seed for compiler sake
  #   @dim_factors = recalc_dim_factors
  #   @cells = Array(Float64).new(@qty_cells) { |i| @seeds[i % @seeds.size] }
  # end

  # def initialize(@dims : Array(Int32) = [1, 1], &seeds_block)
  #   @qty_cells = dims.product(1).to_i32
  #   @dim_factors = [1] # fake value for initial seed for compiler sake
  #   @dim_factors = recalc_dim_factors
  #   @seeds = Array(Float64).new(@qty_cells, seeds_block)
  #   @cells = Array(Float64).new(@qty_cells) do |i|
  #     value = seeds_block.call(i).to_f64
  #     @seeds << value
  #     value
  #   end
  # end

  # alias Errors = Hash(String, OrdinateError)

  def validate_ordinates(ordinates : Ordinates)
    @errors.clear

      # raise OrdinateDimMismatch.new("ordinates: #{ordinates} vs dims: #{dims}, comparing ords size vs dims size: #{ordinates.size} vs #{dims.size}") unless ordinates.size == dims.size
      # raise OrdinateOutOfBounds.new("ordinates: #{ordinates} vs dims: #{dims}, comparing ords OOB: #{dims.map_with_index{|dmax,i| ordinates[i] >= dmax }}") unless dims.map_with_index{|dmax,i| ordinates[i] >= dmax }.any?
      # raise OrdinateError.new("Cell count mis-match") unless ordinates.product(1).to_i32 == @qty_cells
      # @errors["ordinates"] << OrdinateError.new("Cell count mis-match") unless ordinates.product(1).to_i32 == @qty_cells

    if ordinates.size != dims.size
      @errors["ordinates.invalid.dim_mismatch"] = OrdinateDimMismatch.new("ordinates: #{ordinates} vs dims: #{dims}, comparing ords size vs dims size: #{ordinates.size} vs #{dims.size}")
    else
      ord_oob_which = dims.map_with_index do |dmax,i|
        case
        when ordinates[i] < 0
          -1
        when ordinates[i] >= dmax
          1
        else
          0
        end
      end
      ord_oob = ord_oob_which.map{|oob| oob != 0 }
      ord_oob_any = ord_oob.any?
    
      @errors["ordinates.invalid.oob"] = OrdinateOutOfBounds.new("ord_oob_which: #{ord_oob_which}") if ord_oob_any
      #   # @errors["ordinates"] << OrdinateError.new("Cell count mis-match") # unless ordinates.product(1).to_i32 == @qty_cells
      # end
    end
  
    @errors
  end

  def valid?
    errors.nil? || errors.empty? # || errors.keys.empty?
  end

  # def recalc_dim_factors
  #   j = 1
  #   x = @dims[0..-2].map_with_index { |b, i| k = j*b; j = k; k }
  #   @dim_factors = [1] + x
  # end

  # def get_cell_index(ordinates : Array(Int32))
  #   check_ordinates(ordinates)
  #   dims.map_with_index do |_dim, i|
  #     v = ordinates[i]
  #     if i >= 0
  #       v = @dim_factors[i - 1] * v
  #     end
  #     v
  #   end.sum
  # end

  # def get_cell(ordinates : Array(Int32))
  #   @cells[get_cell_index(ordinates)]
  # end
end
