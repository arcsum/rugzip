require 'rugzip/header'
require 'rugzip/trailer'

module Rugzip
  class Compressor
    def initialize(input, output)
      @in, @out = input, output
    end

    def compress
      reset
      
      build_header
      deflate_data
      # TODO: check FTEXT
      build_trailer
      
      write_header
      
      @out
    end
    
    private
    
    def deflate_data
      # TODO
    end
    
    def build_header
      @header = Header.new
      
      if file_input?
        @header.flg.fname!
        @header.mtime = @in.mtime.to_i
      end
    end
    
    def build_trailer
      @trailer = Trailer.new
      # TODO: set CRC-32
      @trailer.isize = @in.size % (2 ** 32)
    end
    
    def file_input?
      @in.is_a?(File)
    end
    
    def reset
      [@in, @out].each(&:rewind)
    end
    
    def write_header
      @out.write(@header.to_s)
    end
  end
end
