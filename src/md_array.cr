# require "./md_array/md_array_f64.cr"
# require "../src/*.cr"
# src/md_array.cr
require "./md_array/md_array_f64.cr"

module MdArray
  VERSION = {{ `shards version "#{__DIR__}"`.chomp.stringify }}
end