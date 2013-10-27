require 'rugzip'
require 'spec_helper'

describe Rugzip do
  subject { Rugzip }

  let(:decompressed) { 'foobar' }

  let(:compressed) do
    "\x1f\x8b\x08\x00\xdf\x95\x6c\x52\x00\x03\x4b\xcb\xcf\x4f\x4a\x2c\x02" \
    "\x00\x95\x1f\xf6\x9e\x06\x00\x00\x00"
  end

  describe 'compress' do
    it 'should compress a simple string' do
      skip
    end
  end
  
  describe 'decompress' do
    let(:input)  { StringIO.new(compressed) }
    let(:output) { StringIO.new }
    
    it 'should decompress a simple string' do
      subject.decompress(input, output)
      output.string.must_equal(decompressed)
    end
  end
end
