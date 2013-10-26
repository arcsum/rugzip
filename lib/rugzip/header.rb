module Rugzip
  class Header
    class Flags
      def initialize(byte)
        @byte = byte
      end

      def ftext?
        set?(0)
      end

      def fhcrc?
        set?(1)
      end

      def fextra?
        set?(2)
      end

      def fname?
        set?(3)
      end

      def fcomment?
        set?(4)
      end

      def to_i
        @byte
      end

      private

      def get(bit_pos)
        (to_i & ( 1 << bit_pos )) >> bit_pos
      end

      def set?(bit_pos)
        get(bit_pos) != 0
      end
    end
    
    STATIC_LEN = 10
    
    ID1 = 0x1f
    ID2 = 0x8b
    
    CM_RANGE = (0..7)
    
    attr_reader :id, :cm, :flg, :mtime, :xfl, :os
    
    def initialize(data)
      bytes = data.unpack('C4LC2')
      
      @id    = bytes[0..1]
      @cm    = bytes[2]
      @flg   = Flags.new(bytes[3])
      @mtime = bytes[4]
      @xfl   = bytes[5]
      @os    = bytes[6]
    end
    
    def valid?
      valid = true
      
      valid = false if id[0] != ID1
      valid = false if id[1] != ID2
      valid = false unless CM_RANGE.cover?(cm)
      
      valid
    end
  end
end