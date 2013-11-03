require 'rugzip/header'
require 'rugzip/trailer'
require 'zlib'

module Rugzip
  class Compressor
    BUF_LEN           = 4096
    COMPRESSION_LEVEL = 8
    
    def initialize(input, output)
      @in, @out = input, output
    end

    def compress
      reset
      write_header
      deflate_data
      write_trailer
      @out
    end
    
    private
    
    def deflate_data
      zstream = Zlib::Deflate.new(COMPRESSION_LEVEL, -Zlib::MAX_WBITS)
      
      while (inflated = @in.read(BUF_LEN))
        # update checksum
        if @crc
          @crc = Zlib.crc32_combine(@crc, Zlib.crc32(inflated), inflated.size)
        else
          @crc = Zlib.crc32(inflated)
        end
        
        deflated = zstream.deflate(inflated, Zlib::FINISH)
        @out.write(deflated)
      end
      
      zstream.finish
      zstream.close
    end
    
    def file_input?
      @in.is_a?(File)
    end
    
    def reset
      [@in, @out].each(&:rewind)
    end
    
    def write_header
      header = Header.new
      
      if file_input?
        header.flg.fname!
        header.mtime = @in.mtime.to_i
      end
      
      @out.write(header.pack)
    end
    
    def write_trailer
      trailer = Trailer.new
      trailer.crc32 = @crc
      trailer.isize = @in.size % (2 ** 32)
      
      @out.write(trailer.pack)
    end
  end
end
