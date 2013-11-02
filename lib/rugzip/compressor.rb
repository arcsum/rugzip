require 'rugzip/header'
require 'rugzip/trailer'

module Rugzip
  class Compressor
    BUF_LEN           = 4096
    COMPRESSION_LEVEL = 8
    
    def initialize(input, output)
      @in, @out = input, output
    end

    def compress
      reset
      
      build_header
      # TODO: check FTEXT
      build_trailer
      
      write_header
      deflate_data
      write_trailer
      
      @out
    end
    
    private
    
    def deflate_data
      zstream = Zlib::Deflate.new(COMPRESSION_LEVEL, -Zlib::MAX_WBITS)
      
      while (inflated = @in.read(BUF_LEN))
        deflated = zstream.deflate(inflated, Zlib::FINISH)
        @out.write(deflated)
      end
      
      zstream.finish
      zstream.close
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
      @out.write(@header.pack)
    end
    
    def write_trailer
      @out.write(@trailer.pack)
    end
  end
end
