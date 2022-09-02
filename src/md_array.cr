class MdArray
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}

  getter qty_cells : Int32 # = 0_u64
  getter dims : Array(Int32) # = [1,1]
  getter seeds : Array(Float64) # = 0_f64
  property cells # : StaticArray

  def initialize(@dims : Array(Int32) = [1,1], @seeds = [0.0])
    # prod = 1
    @qty_cells = dims.product(1).to_i32

    # p! @qty_cells
    # p! @qty_cells.class

    # @qty_cells = qty.to_i32
    @cells = Array(Float64).new(@qty_cells) { |i| @seeds[i % @seeds.size] }
  end

  def initialize(@dims : Array(Int32) = [1,1], &seeds_block : Int32 -> T)
    # prod = 1
    @qty_cells = dims.product(1).to_i32
    # @qty_cells = qty.to_i32
    # p! @qty_cells
    # p! @qty_cells.class

    @seeds = Array(Float64).new(@qty_cells, 0.0)
    @cells = Array(Float64).new(@qty_cells) do |i|
      value = seeds_block.call(i)
      @seeds << value
      value
    end
    # array = uninitialized self
    # N.times do |i|
    #   array.to_unsafe[i] = yield i
    # end
    # array

  end

end
