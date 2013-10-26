require 'rugzip'
require 'spec_helper'
require 'stringio'

describe Rugzip do
  subject { Rugzip }

  let(:decompressed) { 'foobar' }

  let(:compressed) do
    "\x1f\x8b\x08\x00\x2d\x3f\x6b\x52\x00\x03\x4b\xcb\xcf\x4f\x4a\x2c\xe2\x02\x00\x47\x97\x2c\xb2\x07\x00\x00\x00"
  end

  describe '.compress' do
    it 'should compress a simple string' do
      skip
    end
  end
  
  describe '.decompress' do
    it 'should decompress a simple string' do
      input  = StringIO.new(compressed)
      output = StringIO.new
      
      subject.decompress(input, output)
      output.string.must_equal(decompressed)
    end
  end
end
