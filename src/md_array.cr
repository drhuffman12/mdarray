class MdArray
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  class OrdinateError < Exception ; end

  getter qty_cells : Int32 # = 0_u64
  getter dims : Array(Int32) # = [1,1]
  getter seeds : Array(Float64) # = 0_f64
  property cells # : StaticArray

  def initialize(@dims : Array(Int32) = [1,1], @seeds = [0.0])
    @qty_cells = dims.product(1).to_i32
    @cells = Array(Float64).new(@qty_cells) { |i| @seeds[i % @seeds.size] }
  end

  def initialize(@dims : Array(Int32) = [1,1], &seeds_block : Int32 -> T)
    @qty_cells = dims.product(1).to_i32
    @seeds = Array(Float64).new(@qty_cells, 0.0)
    @cells = Array(Float64).new(@qty_cells) do |i|
      value = seeds_block.call(i)
      @seeds << value
      value
    end
  end

  def check_ordinates(ordinates : Array(Int32))
    raise OrdinateError.new("Dim count mis-match") unless ordinates.size == dims.size
    # raise OrdinateError.new("Cell count mis-match") unless ordinates.product(1).to_i32 == @qty_cells
  end

  def get_cell_index(ordinates : Array(Int32))
    check_ordinates(ordinates)

    p! [dims, ordinates]
    
    cell_index = ordinates.first
    factor_index = 1 # dims.first
    p! [factor_index, cell_index]
    dims[1..-2].map_with_index do |dim, i|
      factor_index = factor_index * dims[i-1]
      cell_index += factor_index * ordinates[i]

      p! [factor_index, cell_index, dim, i]
    end
    cell_index
  end

  def get_cell(ordinates : Array(Int32))
    @cells[get_cell_index(ordinates)]
  end
end
