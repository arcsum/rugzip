require 'rugzip/header'
require 'zlib'

module Rugzip
  class Decompressor
    class BadIO < StandardError; end
    
    BUF_LEN     = 4096
    TRAILER_LEN = 8
    
    def initialize(input, output)
      @in, @out = input, output
    end

    def decompress
      reset
      parse_header
      parse_fextra
      parse_fname
      parse_fcomment
      parse_fhcrc
      inflate_data
      parse_trailer
      @out
    end
    
    private
    
    def inflate_data
      zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
      
      # find the # of bytes needed to read the compressed blocks
      data_len = @in.size - TRAILER_LEN - @in.pos
      
      # read the deflated blocks and inflate them
      bytes_read = 0
      while bytes_read < data_len
        bytes_left = data_len - bytes_read
        buflen = [bytes_left, BUF_LEN].min
        
        deflated = @in.read(buflen)
        inflated = zstream.inflate(deflated)
        
        @out.write(inflated)
        bytes_read += deflated.bytesize
      end
      
      zstream.finish
      zstream.close
    end
    
    def parse_fcomment
      return unless @header.flg.fcomment?
      # TODO
    end
    
    def parse_fextra
      return unless @header.flg.fextra?
      
      xlen = @in.read(2).unpack('S').first
      xtra = @in.read(xlen)
      # TODO: parse xtra
    end
    
    def parse_fhcrc
      return unless @header.flg.fhcrc?
    end
    
    def parse_fname
      return unless @header.flg.fname?
      # TODO
    end
    
    def parse_header
      raise BadIO if @in.size < Header::STATIC_LEN
      @header = Header.new(@in.read(Header::STATIC_LEN))
      raise BadIO unless @header.valid?
    end
    
    def parse_trailer
      # TODO
    end
    
    def reset
      [@in, @out].each(&:rewind)
    end
  end
end
