module Rugzip
  class Header
    class Flags
      OFFSET_FTEXT    = 0
      OFFSET_FHCRC    = 1
      OFFSET_FEXTRA   = 2
      OFFSET_FNAME    = 3
      OFFSET_FCOMMENT = 4
      
      def initialize(byte=0)
        @byte = byte
      end

      def ftext?
        set?(OFFSET_FTEXT)
      end
      
      def ftext!
        set(OFFSET_FTEXT)
      end

      def fhcrc?
        set?(OFFSET_FHCRC)
      end
      
      def fhcrc!
        set(OFFSET_FHCRC)
      end

      def fextra?
        set?(OFFSET_FEXTRA)
      end
      
      def fextra!
        set(OFFSET_FEXTRA)
      end

      def fname?
        set?(OFFSET_FNAME)
      end
      
      def fname!
        set(OFFSET_FNAME)
      end

      def fcomment?
        set?(OFFSET_FCOMMENT)
      end
      
      def fcomment!
        set(OFFSET_FCOMMENT)
      end
      
      def get(bit_pos)
        (to_i & ( 1 << bit_pos )) >> bit_pos
      end
      
      def reserved
        (5..7).map { |i| get(i) }
      end
      
      def set(bit_pos)
        @byte |= (1 << bit_pos);
      end
      
      def set?(bit_pos)
        get(bit_pos) != 0
      end

      def to_i
        @byte
      end
      
      def valid?
        reserved.all?(&:zero?)
      end
    end
    
    
    CM_RANGE   = (0..8)
    ID1        = 0x1f
    ID2        = 0x8b
    STATIC_LEN = 10
    UNKNOWN_OS = 255
    
    attr_accessor :id, :cm, :flg, :mtime, :xfl, :os
    
    def initialize(data=nil)
      if data
        bytes = data.unpack('C4LC2')
        
        self.id    = bytes[0..1]
        self.cm    = bytes[2]
        self.flg   = Flags.new(bytes[3])
        self.mtime = bytes[4]
        self.xfl   = bytes[5]
        self.os    = bytes[6]
      else
        self.id    = [ID1, ID2]
        self.cm    = CM_RANGE.last
        self.flg   = Flags.new
        self.mtime = Time.now.to_i
        self.xfl   = 0
        self.os    = current_os
      end
    end
    
    def to_s
      data = ''
      data << [id[0], id[1], cm, flg.to_i].pack('CCCC')
    end
    
    def valid?
      valid = true
      
      valid = false if id[0] != ID1
      valid = false if id[1] != ID2
      valid = false unless CM_RANGE.cover?(cm)
      valid = false unless flg.valid?
      
      valid
    end
    
    private
    
    def current_os
      # TODO: support other OSes
      UNKNOWN_OS
    end
  end
end
