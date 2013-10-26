require 'rugzip/compressor'
require 'rugzip/decompressor'

module Rugzip
  def self.compress(input, output)
    Compressor.new(input, output).compress
  end

  def self.decompress(input, output)
    Decompressor.new(input, output).decompress
  end
end
