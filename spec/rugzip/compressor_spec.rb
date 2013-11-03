require 'rugzip/compressor'
require 'spec_helper'

describe Rugzip::Compressor do
  let(:decompressed) { 'foobar' }

  let(:compressed) do
    "\x1f\x8b\x08\x00\xdf\x95\x6c\x52\x00\x03\x4b\xcb\xcf\x4f\x4a\x2c\x02" \
    "\x00\x95\x1f\xf6\x9e\x06\x00\x00\x00"
  end
  
  let(:input)  { StringIO.new(decompressed) }
  let(:output) { StringIO.new }
  
  subject { Rugzip::Compressor.new(input, output) }
  
  describe '#compress' do
    it 'should compress a simple string' do
      expected_bytes = compressed.bytes
      actual_bytes   = subject.compress.string.bytes
      
      # compare ID1, ID2, CM, FLG
      actual_bytes[0..3].must_equal(expected_bytes[0..3])
      
      # compare compressed blocks and trailer
      actual_bytes[10..25].must_equal(expected_bytes[10..25])
    end
  end
end
