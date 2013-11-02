module Rugzip
  class Trailer
    attr_accessor :crc32, :isize
    
    def initialize
      self.crc32 = 0
      self.isize = 0
    end
    
    def pack
      [crc32, isize].pack('LL')
    end
  end
end
