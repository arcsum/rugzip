require 'rugzip/header'

module Rugzip
  class Compressor
    def initialize(input, output)
      @in, @out = input, output
    end

    def compress
      write_header
      @out
    end
    
    private
    
    def write_header
      header = Header.new
      
    end
  end
end
