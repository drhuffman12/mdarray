# See: https://forum.crystal-lang.org/t/how-to-create-a-non-static-nested-array-with-a-variable-nested-size/5017/2
class MdArray(U)
  def initialize(@array_flattened : Array(U))
  end

  def multi_slice(dims)
    multi_slice(@array_flattened,dims)
  end

  # # e.g.:
  # For an array:
  #   array = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23]
  # If we slice it up in (nested) grids of given dimensions:
  #   dims = [6,4]
  #   multi_slice(array,dims) #=> [[0,1,2,3,4,5],[6,7,8,9,10,11],[12,13,14,15,16,17],[18,19,20,21,22,23]]
  #
  #   dims = [2,12]
  #   multi_slice(array,dims) #=> [[0,1],[2,3],[4,5],[6,7],[8,9],[10,11],[12,13],[14,15],[16,17],[18,19],[20,21],[22,23]]
  #
  #   dims = [2,3,4]
  #   multi_slice(array,dims) #=> [[[0,1],[2,3],[4,5]],[[6,7],[8,9],[10,11]],[[12,13],[14,15],[16,17]],[[18,19],[20,21],[22,23]]]
  #
  def multi_slice(array_from, dims)
    step_size = as_array(dims[0..-1]).product
    array_with_subs = array_from.in_groups_of(step_size)
    case
    when dims.size > 2
      array_with_subs.map{|sub| multi_slice(sub, dims[0..-2])}

      # This errors with:
      #    70 | array_with_subs.map{|sub| multi_slice(sub, dims[0..-2])}
      #    ^--
      #   Error: can't infer block return type, try to cast the block body with `as`. See: https://crystal-lang.org/reference/syntax_and_semantics/as.html#usage-for-when-the-compiler-cant-infer-the-type-of-a-block
      #
      # The problem is that within each recursive loop, the nested-ness of the array increases, so I can't pre-define a block return type.
    when dims.size == 1
      array_with_subs
    else
      array_from
    end
  end

  def as_array(value)
    if value.is_a?(Array)
      value
    else
      [value]
    end
  end
end

# dims = [2]
# dims = [2,3]
dims = [2,3,4]

array_from = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23].map{|v| v.to_f}
p! MdArray.new(array_from).multi_slice(array_from, dims)
