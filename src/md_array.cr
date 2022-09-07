class MdArray
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  class OrdinateError < Exception ; end

  getter qty_cells : Int32 # = 0_u64
  getter dims : Array(Int32) # = [1,1]
  getter dim_factors : Array(Int32) # = [1,1]
  getter seeds : Array(Float64) # = 0_f64
  property cells # : StaticArray

  def initialize(@dims : Array(Int32) = [1,1], @seeds = [0.0])
    @qty_cells = dims.product(1).to_i32
    @dim_factors = [1] # fake value for initial seed for compiler sake
    @dim_factors = recalc_dim_factors
    @cells = Array(Float64).new(@qty_cells) { |i| @seeds[i % @seeds.size] }
  end

  def initialize(@dims : Array(Int32) = [1,1], &seeds_block)
    @qty_cells = dims.product(1).to_i32
    @dim_factors = [1] # fake value for initial seed for compiler sake
    @dim_factors = recalc_dim_factors
    @seeds = Array(Float64).new(@qty_cells, seeds_block)
    @cells = Array(Float64).new(@qty_cells) do |i|
      value = seeds_block.call(i).to_f64
      @seeds << value
      value
    end
  end

  def check_ordinates(ordinates : Array(Int32))
    raise OrdinateError.new("Dim count mis-match") unless ordinates.size == dims.size
    # raise OrdinateError.new("Cell count mis-match") unless ordinates.product(1).to_i32 == @qty_cells
  end

  def recalc_dim_factors
    j = 1
    x = @dims[0..-2].map_with_index{|b,i| k = j*b; j = k; k }
    @dim_factors = [1] + x
  end

  def get_cell_index(ordinates : Array(Int32))
    check_ordinates(ordinates)
    dims.map_with_index do |dim, i|
      v = ordinates[i]
      if i >= 0
        v = @dim_factors[i-1] * v
      end
      v
    end.sum
  end

  def get_cell(ordinates : Array(Int32))
    @cells[get_cell_index(ordinates)]
  end
end
