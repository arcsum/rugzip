require 'rugzip/header'
require 'zlib'

module Rugzip
  class Decompressor
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
    end
    
    private
    
    def inflate_data
      # find the # of bytes needed to read the compressed blocks and read them
      data_len = @in.size - TRAILER_LEN - @in.pos
      deflated = @in.read(data_len)
      
      # inflate the compressed blocks
      zstream = Zlib::Inflate.new(-Zlib::MAX_WBITS)
      inflated = zstream.inflate(deflated)
      zstream.finish
      zstream.close
      
      @out.write(inflated)
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
      @header = Header.new(@in.read(Header::STATIC_LEN))
      raise 'yo, make an error for this later' unless @header.valid?
    end
    
    def parse_trailer
      # TODO
    end
    
    def reset
      [@in, @out].each(&:rewind)
    end
  end
end
