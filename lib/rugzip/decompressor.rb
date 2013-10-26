require 'rugzip/header'

module Rugzip
  class Decompressor
    def initialize(input, output)
      @in, @out = input, output
    end

    def decompress
      reset
      parse_header
      ''
    end
    
    private
    
    def parse_header
      @header = Header.new(@in.read(Header::STATIC_LEN))
      raise 'yo, make an error for this later' unless @header.valid?
    end
    
    def reset
      [@in, @out].each(&:rewind)
    end
  end
end
